$TTL 	1s
@ 	IN 	SOA 	ns.zX.lab.vs. root.ns.zX.lab.vs. (
		1 	; Serial
		604800 	; Refresh
		86400 	; Retry
		2419200 ; Expire
		604800 ) ; Negative Cache TTL
;
		IN 	NS 	ns
localhost 	IN 	A 	127.0.0.1
ns 		IN 	A 	192.168.200.ZZZ
host1 		IN 	A 	192.168.201.YYY
host2 		IN 	A 	192.168.201.YYY
host3 		IN 	A 	192.168.201.YYY
hostn1 		IN 	A 	192.168.200.ZZZ
hostn2 		IN 	A 	192.168.200.ZZZ
