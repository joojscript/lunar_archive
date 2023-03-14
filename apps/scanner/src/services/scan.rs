use crate::{
    common::services::ScanStatus,
    generated::{common::Protocol, services::ScanResult},
};
use rayon::prelude::*;
use regex::Regex;
use std::{
    borrow::Cow,
    process::{Command, Stdio},
};

pub fn perform_scan(ports: &Vec<&str>) -> Result<Vec<ScanResult>, Box<dyn std::error::Error>> {
    match Command::new("rustscan")
        .args([
            "-a",
            "192.168.0.114",
            "-p",
            parse_ports(ports).unwrap().join(",").as_str(),
        ])
        .stderr(Stdio::piped())
        .output()
    {
        Ok(output) => {
            // println!("Was spawned :)");
            // println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
            let output = String::from_utf8_lossy(&output.stdout);
            parse_response(&output)
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

fn parse_ports<'a>(ports: &'a Vec<&str>) -> Result<Vec<String>, Box<dyn std::error::Error>> {
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

fn parse_response(output: &Cow<str>) -> Result<Vec<ScanResult>, Box<dyn std::error::Error>> {
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
                hostname: "".to_string(),
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
