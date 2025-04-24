#!/bin/bash

#Variables
ip="" #Ip
port_range="" #Port Range
auto_generate_report=false # Generate report
scan_udp=false  #Enable UDP scan
REPORTS_DIR="Scanned_Ports" #Name of directory where reports will be saved

#Creates the reports directory in case it does not exist
mkdir -p "$REPORTS_DIR"

#Function to scan TCP ports using nmap
scan_ports_tcp() {
    if [ -z "$ip" ] || [ -z "$port_range" ]; then
        read -p "Enter the IP or domain to scan: " ip
        read -p "Enter the port range to scan (example: 1-1000): " port_range
    fi

    #Get the current date and time
    timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
    report_file="$REPORTS_DIR/tcp_scan_${timestamp}.txt"

    echo "Scanning TCP ports on $ip..."

    #Create report file with header
    echo "===== TCP SCAN: $timestamp =====" > "$report_file"
    echo "Ip/Domain: $ip" >> "$report_file"
    echo "Port range: $port_range" >> "$report_file"
    echo "--------------------------------" >> "$report_file"

    #Run nmap and capture output
    nmap_output=$(nmap -p $port_range -T4 $ip)

    if [ $? -eq 0 ]; then
        echo "$nmap_output" >> "$report_file"

        #Find open and closed ports
        open_ports=$(echo "$nmap_output" | grep -oP '\d+/tcp\s+open' | awk '{print $1}')
        closed_ports=$(echo "$nmap_output" | grep -oP '\d+/tcp\s+closed' | awk '{print $1}')

        #Display results and add them to the report
        if [ -z "$open_ports" ]; then
            echo "No open TCP ports found on $ip." >> "$report_file"
            echo "No open TCP ports found on $ip."
        else
            echo "Open TCP ports on $ip: $open_ports" >> "$report_file"
            echo "Open TCP ports on $ip: $open_ports"
        fi

        if [ -z "$closed_ports" ]; then
            echo "No closed TCP ports found on $ip." >> "$report_file"
            echo "No closed TCP ports found on $ip."
        else
            echo "Closed TCP ports on $ip: $closed_ports" >> "$report_file"
            echo "Closed TCP ports on $ip: $closed_ports"
        fi
    else
        echo "Scan failed. Check the IP/Domain or port range." >> "$report_file"
        echo "Scan failed. Check the IP/Domain or port range."
    fi

    echo "================================" >> "$report_file"
    echo "Scan completed. Report saved to: $report_file"

    ip=""
    port_range=""
}

#Function to scan UDP ports using nmap
scan_ports_udp() {
    if [ -z "$ip" ] || [ -z "$port_range" ]; then
        read -p "Enter the IP or domain to scan: " ip
        read -p "Enter the UDP port range to scan (example: 1-1000): " port_range
    fi

    timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
    report_file="$REPORTS_DIR/udp_scan_${timestamp}.txt"

    echo "Scanning UDP ports on $ip..."

    echo "===== UDP SCAN: $timestamp =====" > "$report_file"
    echo "Ip/Domain: $ip" >> "$report_file"
    echo "UDP Port range: $port_range" >> "$report_file"
    echo "--------------------------------" >> "$report_file"

    nmap_output=$(nmap -sU -p $port_range -T4 $ip)

    if [ $? -eq 0 ]; then
        echo "$nmap_output" >> "$report_file"

        open_ports=$(echo "$nmap_output" | grep -oP '\d+/udp\s+open' | awk '{print $1}')
        closed_ports=$(echo "$nmap_output" | grep -oP '\d+/udp\s+closed' | awk '{print $1}')

        if [ -z "$open_ports" ]; then
            echo "No open UDP ports found on $ip." >> "$report_file"
            echo "No open UDP ports found on $ip."
        else
            echo "Open UDP ports on $ip: $open_ports" >> "$report_file"
            echo "Open UDP ports on $ip: $open_ports"
        fi

        if [ -z "$closed_ports" ]; then
            echo "No closed UDP ports found on $ip." >> "$report_file"
            echo "No closed UDP ports found on $ip."
        else
            echo "Closed UDP ports on $ip: $closed_ports" >> "$report_file"
            echo "Closed UDP ports on $ip: $closed_ports"
        fi
    else
        echo "UDP scan failed. Check the IP/Domain or port range." >> "$report_file"
        echo "UDP scan failed. Check the IP/Domain or port range."
    fi

    echo "================================" >> "$report_file"
    echo "Scan completed. Report saved to: $report_file"

    ip=""
    port_range=""
}

#Function to list all scan reports
list_reports() {
    echo "Available scan reports:"
    ls -lt "$REPORTS_DIR" 2>/dev/null || echo "No reports available."
}

#Function to analyze scan results, which indicates how many ports are openned or close
analyze_results() {
    list_reports
    read -p "Enter the report filename to analyze (or leave blank for most recent): " report_name
    
    if [ -z "$report_name" ]; then
        report_name=$(ls -t "$REPORTS_DIR" | head -n 1)
    fi
    
    report_path="$REPORTS_DIR/$report_name"
    
    if [ ! -f "$report_path" ]; then
        echo "Report not found: $report_name"
        return
    fi
    
    echo "Analyzing $report_name..."
    open_ports=$(grep -oP 'open' "$report_path" | wc -l)
    closed_ports=$(grep -oP 'closed' "$report_path" | wc -l)
    echo "Open ports: $open_ports"
    echo "Closed ports: $closed_ports"
}

#Function to clear all reports
clear_reports() {
    rm -f "$REPORTS_DIR"/*
    echo "All scan reports have been cleared."
}

#Menu
show_menu() {
    echo ""
    echo "======= PORT SCANNER MENU ======="
    echo "1- Scan TCP ports"
    echo "2- Scan UDP ports"
    echo "3- List scan reports"
    echo "4- Analyze scan results"
    echo "5- Clear all reports"
    echo "6- Exit"
}

#Process the parameters
while getopts ":i:p:ru" opt; do
    case $opt in
        i) ip="$OPTARG" ;; #IP or domain
        p) port_range="$OPTARG" ;; #Port range
        r) auto_generate_report=true ;; #Automatically generate the report
        u) scan_udp=true ;; #Enable UDP scan
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

#Check if input parameters were provided
if [ -n "$ip" ] && [ -n "$port_range" ]; then
    if [ "$scan_udp" = true ]; then
        scan_ports_udp
    else
        scan_ports_tcp
    fi
    exit 0
fi

#Main menu loop
while true; do
    show_menu
    read -p "Choose an option: " choice
    case $choice in
        1)
            scan_ports_tcp
            ;;
        2)
            scan_ports_udp
            ;;
        3)
            list_reports
            ;;
        4)
            analyze_results
            ;;
        5)
            clear_reports
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option, try again."
            ;;
    esac
done
