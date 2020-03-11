if dpkg -l | grep "unifi " | grep -q "^ii"; then
  inform_port=$(grep "^unifi.http.port" /usr/lib/unifi/data/system.properties | cut -d'=' -f2 | tail -n1)
  dashboard_port=$(grep "^unifi.https.port" /usr/lib/unifi/data/system.properties | cut -d'=' -f2 | tail -n1)
  clear
  header
  echo ""
  echo -e "${GREEN}#${RESET} UniFi Network Controller 5.12.35 has been installed successfully"
  if [[ "${remote_controller}" = 'true' ]]; then
    echo -e "${GREEN}#${RESET} Your controller address: ${WHITE_R}https://$PUBLIC_SERVER_IP:${dash_port}${RESET}"
    if [[ "${le_script}" == 'true' ]]; then
      if [[ -d /usr/lib/EUS/ ]]; then
        if [[ -f /usr/lib/EUS/server_fqdn_install && -s /usr/lib/EUS/server_fqdn_install ]]; then
          controller_fqdn_le=$(tail -n1 /usr/lib/EUS/server_fqdn_install)
          rm --force /usr/lib/EUS/server_fqdn_install &> /dev/null
        fi
      elif [[ -d /srv/EUS/ ]]; then
        if [[ -f /srv/EUS/server_fqdn_install && -s /srv/EUS/server_fqdn_install ]]; then
          controller_fqdn_le=$(tail -n1 /srv/EUS/server_fqdn_install)
          rm --force /srv/EUS/server_fqdn_install &> /dev/null
        fi
      fi
      if [[ -n "${controller_fqdn_le}" ]]; then
        echo -e "${GREEN}#${RESET} Your controller FQDN: ${WHITE_R}https://$controller_fqdn_le:${dash_port}${RESET}"
      fi
    fi
  else
    echo -e "${GREEN}#${RESET} Your controller address: ${WHITE_R}https://$SERVER_IP:${dash_port}${RESET}"
  fi
  echo ""
  echo ""
  if [[ "${os_codename}" =~ (precise|maya|trusty|qiana|rebecca|rafaela|rosa) ]]; then
    service unifi status | grep -q running && echo -e "${GREEN}#${RESET} UniFi is active ( running )" || echo -e "${RED}#${RESET} UniFi failed to start... Please contact Glenn R. (AmazedMender16) on the Community Forums!"
  else
    systemctl is-active -q unifi && echo -e "${GREEN}#${RESET} UniFi is active ( running )" || echo -e "${RED}#${RESET} UniFi failed to start... Please contact Glenn R. (AmazedMender16) on the Community Forums!"
  fi
  if [[ "${change_unifi_ports}" == 'true' ]]; then
    echo -e "\\n${WHITE_R}---- ${RED}NOTE${WHITE_R} ----${RESET}\\n\\n${WHITE_R}#${RESET} Your default controller port(s) have changed!\\n"
    if [[ -n "${inform_port}" ]]; then
      echo -e "${WHITE_R}#${RESET} Device Inform port: ${inform_port}"
    fi
    if [[ -n "${dashboard_port}" ]]; then
      echo -e "${WHITE_R}#${RESET} Management Dashboard port: ${dashboard_port}"
    fi
    echo -e "\\n${WHITE_R}--------------${RESET}\\n"
  else
    if [[ "${port_8080_in_use}" == 'true' && "${port_8443_in_use}" == 'true' && "${port_8080_pid}" == "${port_8443_pid}" ]]; then
      echo -e "\\n${RED}#${RESET} Port ${info_port} and ${dash_port} is already in use by another process ( PID ${port_8080_pid} ), your UniFi Network Controll will most likely not start.."
      echo -e "${RED}#${RESET} Disable the service that is using port ${info_port} and ${dash_port} ( ${port_8080_service} ) or kill the process with the command below"
      echo -e "${RED}#${RESET} sudo kill -9 ${port_8080_pid}\\n"
    else
      if [[ "${port_8080_in_use}" == 'true' ]]; then
        echo -e "\\n${RED}#${RESET} Port ${info_port} is already in use by another process ( PID ${port_8080_pid} ), your UniFi Network Controll will most likely not start.."
        echo -e "${RED}#${RESET} Disable the service that is using port ${info_port} ( ${port_8080_service} ) or kill the process with the command below"
        echo -e "${RED}#${RESET} sudo kill -9 ${port_8080_pid}\\n"
      fi
      if [[ "${port_8443_in_use}" == 'true' ]]; then
        echo -e "\\n${RED}#${RESET} Port ${dash_port} is already in use by another process ( PID ${port_8443_pid} ), your UniFi Network Controll will most likely not start.."
        echo -e "${RED}#${RESET} Disable the service that is using port ${dash_port} ( ${port_8443_service} ) or kill the process with the command below"
        echo -e "${RED}#${RESET} sudo kill -9 ${port_8443_pid}\\n"
      fi
    fi
  fi
  echo -e "\\n"
  author
  remove_yourself
else
  clear
  header_red
  echo -e "\\n${RED}#${RESET} Failed to successfully install UniFi Network Controller 5.12.35"
  echo -e "${RED}#${RESET} Please contact Glenn R. (AmazedMender16) on the Community Forums!${RESET}"
  echo -e "\\n"
  remove_yourself
fi