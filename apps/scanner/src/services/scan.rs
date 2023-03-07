use regex::Regex;

pub fn perform_scan(ports: Vec<&str>) -> Result<(), Box<dyn std::error::Error>> {
    Ok(())
}

pub fn parse_ports(ports: Vec<&str>) -> Result<Vec<u16>, Box<dyn std::error::Error>> {
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
        let protocol = match captures.get(2) {
            Some(protocol) => protocol.as_str(),
            None => "all",
        };

        println!("{} - {} - {:?}", start_port, end_port, protocol);
        // let parsed_port = port.parse::<u16>()?;
        // parsed_ports.push(parsed_port);
    }
    Ok(parsed_ports)
}
