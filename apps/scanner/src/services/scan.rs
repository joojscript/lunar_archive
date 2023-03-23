use crate::{
    common::services::{self, ScanStatus},
    generated::{common::Protocol, services::ScanResult},
};
use rayon::prelude::*;
use regex::Regex;
use std::{
    borrow::Cow,
    process::{Command, Stdio},
};

pub fn perform_scan(
    scan_request: &services::ScanRequest,
) -> Result<Vec<ScanResult>, Box<dyn std::error::Error>> {
    let command_arguments = if scan_request.ports.is_empty() {
        vec![
            String::from("-a"),
            scan_request.hostname.clone(),
            String::from(""),
            String::from(""),
        ]
    } else {
        let parsed_ports_array = parse_ports(scan_request.ports.clone())?;
        let parsed_ports = parsed_ports_array.join(",");
        vec![
            String::from("-a"),
            scan_request.hostname.clone(),
            String::from("-p"),
            parsed_ports,
        ]
    };

    match Command::new("rustscan")
        .args(command_arguments)
        .stderr(Stdio::piped())
        .output()
    {
        Ok(output) => {
            // println!("Was spawned :)");
            // println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
            let output = String::from_utf8_lossy(&output.stdout);
            parse_response(&output, &scan_request)
        }
        Err(e) => {
            if let std::io::ErrorKind::NotFound = e.kind() {
                println!("`rustscan` was not found! Check your PATH!");
            } else {
                println!("Some strange error occurred :(");
            }
            Err(Box::new(e))
        }
    }
}

fn parse_ports(ports: Vec<String>) -> Result<Vec<String>, Box<dyn std::error::Error>> {
    let single_port_parse_regex: Regex = Regex::new(r"(\d+-\d+|\d+)/?(.+)?").unwrap();
    let mut parsed_ports = Vec::new();
    for port in ports {
        let captures = single_port_parse_regex.captures(&port).unwrap();
        let single_port_or_port_range = captures.get(1).unwrap().as_str();
        let (start_port, end_port) = if single_port_or_port_range.contains("-") {
            let ports: Vec<&str> = single_port_or_port_range.split("-").collect();
            (ports[0], ports[1])
        } else {
            (single_port_or_port_range, single_port_or_port_range)
        };

        // For now, protocol is extracted, but ignored
        let _protocol = match captures.get(2) {
            Some(protocol) => protocol.as_str(),
            None => "all",
        };

        if start_port == end_port {
            parsed_ports.push(start_port.to_string());
        } else {
            let start_port = start_port.parse::<u16>()?;
            let end_port = end_port.parse::<u16>()?;
            for port in start_port..=end_port {
                parsed_ports.push(port.to_string());
            }
        }
    }

    Ok(parsed_ports)
}

fn parse_response(
    output: &Cow<str>,
    scan_request: &services::ScanRequest,
) -> Result<Vec<ScanResult>, Box<dyn std::error::Error>> {
    let scan_parser_regex =
        Regex::new(r"(?im)(\d+)/([A-Za-z-]+)\s+([A-Za-z-]*)\s+([A-Za-z-]*)\s+([A-Za-z-]*)")
            .unwrap();

    let result = output
        .par_lines()
        .filter_map(|line| scan_parser_regex.captures(&line).or(None))
        .map(|captures| {
            let port = captures.get(1).unwrap().as_str();
            let protocol = captures.get(2).unwrap().as_str();
            let status = captures.get(3).unwrap().as_str();
            let service = captures.get(4).unwrap().as_str();
            let signal = captures.get(5).unwrap().as_str();

            let scan_result = ScanResult {
                hostname: scan_request.hostname.clone(),
                port: port.to_string(),
                status: match status {
                    "open" => ScanStatus::Open.into(),
                    "closed" => ScanStatus::Closed.into(),
                    _ => ScanStatus::Unknown.into(),
                },
                protocol: match protocol {
                    "tcp" => Protocol::Tcp.into(),
                    "udp" => Protocol::Udp.into(),
                    _ => Protocol::Unknown.into(),
                },
                service: service.to_string(),
                signal: signal.to_string(),
                ..Default::default()
            };

            scan_result
        })
        .collect();

    Ok(result)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_ports() {
        let ports = vec![
            String::from("80"),
            String::from("443"),
            String::from("8080"),
            String::from("1-1000"),
            String::from("1000-1"),
            String::from("1-1000/tcp"),
            String::from("1-1000/udp"),
            String::from("1-1000/"),
            String::from("1-1000/ssh"),
        ];

        let parsed_ports = parse_ports(ports).unwrap();
        assert_eq!(parsed_ports.len(), 5003);
        assert_eq!(parsed_ports[0], "80");
        assert!(parsed_ports.contains(&"443".to_string()));
        assert!(parsed_ports.contains(&"8080".to_string()));
        assert!(parsed_ports.contains(&"1".to_string()));
        assert!(parsed_ports.contains(&"1000".to_string()));
        assert!(parsed_ports.contains(&"500".to_string()));
        assert!(parsed_ports.contains(&"670".to_string()));
    }

    #[test]
    fn test_parse_response() {
        let output = "
        PORT      STATE SERVICE      REASON
        21/tcp    open  ftp          syn-ack
        23/tcp    open  telnet       syn-ack
        53/tcp    open  domain       syn-ack
        80/tcp    open  http         syn-ack
        139/tcp   open  netbios-ssn  syn-ack
        445/tcp   open  microsoft-ds syn-ack
        1900/tcp  open  upnp         syn-ack
        7547/tcp  open  cwmp         syn-ack
        57771/tcp open  unknown      syn-ack";
        let scan_request = services::ScanRequest {
            hostname: String::from("192.168.0.114"),
            ports: vec![],
            action: 0,
        };
        let scan_results = parse_response(&output.into(), &scan_request).unwrap();

        let tcp_value: i32 = Protocol::Tcp.into();
        let open_value: i32 = ScanStatus::Open.into();

        assert_eq!(scan_results.len(), 9);
        assert_eq!(scan_results[0].port, "21");
        assert_eq!(scan_results[1].status, open_value);
        assert_eq!(scan_results[2].protocol, tcp_value);
        assert_eq!(scan_results[3].service, "http");
        assert_eq!(scan_results[4].signal, "syn-ack");
    }

    #[test]
    fn test_parse_response_with_empty_lines() {
        let output = "
        PORT      STATE SERVICE      REASON
        21/tcp    open  ftp          syn-ack
        23/tcp    open  telnet       syn-ack
        53/tcp    open  domain       syn-ack
        80/tcp    open  http         syn-ack
        139/tcp   open  netbios-ssn  syn-ack
        445/tcp   open  microsoft-ds syn-ack
        1900/tcp  open  upnp         syn-ack
        7547/tcp  open  cwmp         syn-ack
        57771/tcp open  unknown      syn-ack

        ";
        let scan_request = services::ScanRequest {
            hostname: String::from("192.168.0.114"),
            ports: vec![],
            action: 0,
        };
        let scan_results = parse_response(&output.into(), &scan_request).unwrap();

        let tcp_value: i32 = Protocol::Tcp.into();
        let open_value: i32 = ScanStatus::Open.into();

        assert_eq!(scan_results.len(), 9);
        assert_eq!(scan_results[0].port, "21");
        assert_eq!(scan_results[1].status, open_value);
        assert_eq!(scan_results[2].protocol, tcp_value);
        assert_eq!(scan_results[3].service, "http");
        assert_eq!(scan_results[4].signal, "syn-ack");
    }
}
