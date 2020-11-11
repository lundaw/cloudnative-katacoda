#!/bin/bash

show_progress()
{
    printf "\033c"
    echo -n "Configuring k8s"
    local spinstr='\|/-'
    while true; do
        grep -i "done" /root/setup-finished &> /dev/null
        if [[ "$?" -ne 0 ]]; then
            local temp="${spinstr#?}"
            printf " [%c]" "${spinstr}"
            spinstr=${temp}${spinstr%"${temp}"}
            sleep "0.5"
            printf "\b\b\b\b"
        else
            break
        fi
    done

    echo "Environment is ready"
}

show_progress