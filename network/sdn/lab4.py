#!/usr/bin/python

from mininet.net import Mininet
from mininet.node import OVSKernelSwitch, RemoteController
from mininet.cli import CLI
from mininet.util import dumpNodeConnections
from mininet.log import setLogLevel

def simpleTest():
    "Create and test a simple network"
    net = Mininet(controller=RemoteController, switch=OVSKernelSwitch)

    "Create nodes in the network"
    c0 = net.addController('c0', controller=RemoteController, ip='127.0.0.1', port=6633)
    h1 = net.addHost('h1', ip='192.168.1.1/24')
    h2 = net.addHost('h2', ip='192.168.1.2/24')
    s1 = net.addSwitch('s1')
    s2 = net.addSwitch('s2')

    "Disable ipv6 protocol"
    for h in net.hosts:
      h.cmd("sysctl -w net.ipv6.conf.all.disable_ipv6=1")
      h.cmd("sysctl -w net.ipv6.conf.default.disable_ipv6=1")
      h.cmd("sysctl -w net.ipv6.conf.lo.disable_ipv6=1")

    for sw in net.switches:
      sw.cmd("sysctl -w net.ipv6.conf.all.disable_ipv6=1")
      sw.cmd("sysctl -w net.ipv6.conf.default.disable_ipv6=1")
      sw.cmd("sysctl -w net.ipv6.conf.lo.disable_ipv6=1")

    "Creating links between nodes in network"
    net.addLink(h1, s1)
    net.addLink(h2, s2)
    net.addLink(s1, s2)

    "Run pingall test"
    net.start()
    print('Dumping host connections')
    dumpNodeConnections(net.hosts)
    print('Testing network connectivity')
    net.pingAll()
    CLI(net)
    net.stop()

if __name__ == '__main__':
    setLogLevel('info')
    simpleTest()

