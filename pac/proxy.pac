function FindProxyForURL(url, host) {
    var blacklist = [

        'aistudio.google.com',

        'openai.com',
        '*.openai.com',

        'cloudflare.com',
        '*.cloudflare.com',

        'xreal.com',
        '*.xreal.com',

        'synology.com',
        '*.synology.com',

        'vpnbook.com',
        '*.vpnbook.com',

        'medium.com',
        '*.medium.com',

        'suno.com',
        '*.suno.com',

        'mailgun.com',
        '*.mailgun.com',

        'heroku.com',
        '*.heroku.com',

        'play.google.com',

        'lantern.io',
        '*.lantern.io',

        'patreon.com',
        '*.patreon.com',

        'chatgpt.com',
        '*.chatgpt.com',

        'hashicorp.com',
        '*.hashicorp.com',
        'vagrantcloud.com',
        '*.vagrantcloud.com',
        'amazonaws.com',
        '*.amazonaws.com',

        'googlevideo.com',
        '*.googlevideo.com',

        'nnmclub.to',
        '*.nnmclub.to',

        'facebook.com',
        '*.facebook.com',

        'instagram.com',
        '*.instagram.com',

        '*.jetbra.*',
        'jetbrains.com',
        '*.jetbrains.com',

        'youtube.com',
        '*.youtube.com',

        'ggpht.com',
        '*.ggpht.com',

        'ytimg.com',
        '*.ytimg.com',

        'i.ytimg.com',
        '*.i.ytimg.com',

        'torproject.org',
        '*.torproject.org',

        '*.tv',
        '*.to',

    ];

    if (!host) return "DIRECT";

    var hostOnly = host.split(':')[0].toLowerCase();

    for (var i = 0; i < blacklist.length; i++) {
        if (shExpMatch(hostOnly, blacklist[i])) {
            return "SOCKS5 localhost:9050; SOCKS5 localhost:9150; DIRECT";
        }
    }

    return "DIRECT";
}
