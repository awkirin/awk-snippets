//     var whitelist = [
//         "www.google.com",
//         "www.github.com",
//         "www.stackoverflow.com"
//     ];
//
//     for (var i = 0; i < whitelist.length; i++) {
//         if (dnsDomainIs(host, whitelist[i])) {
//             return "DIRECT";
//         }
//     }


//     return "SOCKS5 127.0.0.1:9050;";

//     // Если запрашиваемый веб-сайт находится в пределах внутренней сети, отправляем напрямую.
//     if (isPlainHostName(host) ||
//         shExpMatch(host, "*.local") ||
//         isInNet(dnsResolve(host), "10.0.0.0", "255.0.0.0") ||
//         isInNet(dnsResolve(host), "172.16.0.0", "255.240.0.0") ||
//         isInNet(dnsResolve(host), "192.168.0.0", "255.255.0.0") ||
//         isInNet(dnsResolve(host), "127.0.0.0", "255.0.0.0") ||
//         isInNet(dnsResolve(host), "169.254.0.0", "255.255.0.0") ||
//         isInNet(dnsResolve(host), "100.64.0.0", "255.192.0.0") ||
//         isInNet(dnsResolve(host), "192.0.0.0", "255.255.255.0") ||
//         isInNet(dnsResolve(host), "192.0.2.0", "255.255.255.0") ||
//         isInNet(dnsResolve(host), "198.18.0.0", "255.254.0.0") ||
//         isInNet(dnsResolve(host), "198.51.100.0", "255.255.255.0") ||
//         isInNet(dnsResolve(host), "203.0.113.0", "255.255.255.0") ||
//         isInNet(dnsResolve(host), "224.0.0.0", "240.0.0.0") ||
//         isInNet(dnsResolve(host), "240.0.0.0", "240.0.0.0") ||
//         isInNet(dnsResolve(host), "255.255.255.255", "255.255.255.255")) {
//         return "DIRECT";
//     }










    var blacklist = [
        'googlevideo.com',
        'ya.ru',
        'yandex.ru',
    ];

    for (var j = 0; j < blacklist.length; j++) {
        if (dnsDomainIs(host, blacklist[j])) {
            return "SOCKS5 127.0.0.1:9050";
        }
    }



// // Если хост соответствует, отправляем напрямую.
//     if (dnsDomainIs(host, "intranet.domain.com") ||
//         shExpMatch(host, "*.abcdomain.com")) {
//         return "DIRECT";
//     }
//
//     // Если протокол или URL соответствуют, отправляем напрямую.
//     if (url.substring(0, 4) == "ftp:" ||
//         shExpMatch(url, "http://abcdomain.com/folder/*")) {
//         return "DIRECT";
//     }
//
//     // Если запрашиваемый веб-сайт находится в пределах внутренней сети, отправляем напрямую.
//     if (isPlainHostName(host) ||
//         shExpMatch(host, "*.local") ||
//         isInNet(dnsResolve(host), "10.0.0.0", "255.0.0.0") ||
//         isInNet(dnsResolve(host), "172.16.0.0", "255.240.0.0") ||
//         isInNet(dnsResolve(host), "192.168.0.0", "255.255.0.0") ||
//         isInNet(dnsResolve(host), "127.0.0.0", "255.255.255.0")) {
//         return "DIRECT";
//     }
//
//     // Если IP-адрес локальной машины находится в определённой подсети, отправляем на конкретный прокси.
//     if (isInNet(myIpAddress(), "10.10.5.0", "255.255.255.0")) {
//         return "PROXY 1.2.3.4:8080";
//     }
//
//     // РЕШЕНИЕ ПО УМОЛЧАНИЮ: Для всего остального трафика используем указанные прокси в порядке резервирования.
//     return "PROXY 4.5.6.7:8080; PROXY 7.8.9.10:8080";









//   if (isInNet(myIpAddress(), "1.2.3.0", "255.255.255.0")) {
//     if (isInNet(host, "192.168.0.0", "255.255.0.0"))
//       return "DIRECT";
//     if (shExpMatch(url, "http:*"))
//       return "PROXY my.proxy.com:8000" ;
//     if (shExpMatch(url, "https:*"))
//       return "PROXY my.proxy.com:8000" ;
//     if (shExpMatch(url, "ftp:*"))
//       return "PROXY my.proxy.com:8000" ;
//     return "DIRECT";
//   } else {
//     return "DIRECT";
//   }