# GENIX: A GENI-based IXP Emulation

It is a modular emulation framework that mimics the behavior of Internet eXchange Points (IXPs) on a public networking test-bed. GENIX is implemented in Global Environment for Network Innovations (GENI) and capable of enumerating various interactions among ISPs, expected in the real world. GENIX is the first effort towards alleviating the complexities of large-scale emulation to abstract a lightweight design where IXP dynamics can be usefully applied. We test GENIX for its ability to handle large volumes of traffic flow and its performance during network congestion.

## Private Peering Topology:
![Private Peering](/assets/images/private_abstract.png)

## Public Peering Topology:
![Public Peering](/assets/images/private_abstract.png)

We implement a fat-tree vitual switch topology that connects all member ISPs as part of the public and private peering network.

## Guidlines for testing
### Step One:
Get access to GENI portal. You will need to log in using an affiliated college/university.

### Step Two:
Create a slice and add resources by using the /Public/GENIX/public_8.xml or /Private/GENIX/private_8.xml as the request rsepc for public or private peering topologies respectively.

### Step Three:
Wait till the nodes are ready and configured. Once the status changes to ready, the setup is complete.

*The included scripts handle resource management, but they do not guarantee perfect execution*
