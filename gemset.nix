{
  actioncable = {
    dependencies = ["actionpack" "activesupport" "nio4r" "websocket-driver" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "046k9cnw8vqlf4q4i2aywr5rf02k2081238z2rf3vada3ijshyvq";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail" "net-imap" "net-pop" "net-smtp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l6ahdd20zimpq8crfw9ng8w288giv3daklbw6df95s5lhck1zd3";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "net-imap" "net-pop" "net-smtp" "rails-dom-testing"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l835a50h95wlzcy76c2vg54ix3i55kqmnrmz67b11q5fjb6068z";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "nokogiri" "racc" "rack" "rack-session" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lpd0lvn6abcq5k8g0qw8kmzx6igirlqxvd1hhwmr5vaxhdwgbyw";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "globalid" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "115p772dc19qvywyz9pgzh1fb3g2457hhh96shcrijd3jnp4v5l4";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nv1ifjhm59abc52k2hwazl38r9cc4bkfgdsl00f24gc5ljgbz21";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  active_model_serializers = {
    dependencies = ["actionpack" "activemodel" "case_transform" "jsonapi-renderer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13n1ipn0dg3k852xhfzdvkr1ljq76xvfnm79qzdix2ishiy1gphl";
      type = "gem";
    };
    version = "0.10.14";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qhg0izdckgyqmrsgigh1vkqg8ccrkdjhf36k9gxcbgvzpqfx2iz";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wmdw440l4h75zk6c4ynbnv21bj26dh8kb1kwikqkjnzfvm3ij7l";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "timeout"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wihj9xhr7yj10hh8fqw6ralanbwlisncbam8pa92czjssjfqkkq";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  activestorage = {
    dependencies = ["actionpack" "activejob" "activerecord" "activesupport" "marcel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bhardfnmyynd04si8989g5yw5fnj4f2a5cs1945w43ylyh0w0pj";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  activesupport = {
    dependencies = ["base64" "bigdecimal" "concurrent-ruby" "connection_pool" "drb" "i18n" "minitest" "mutex_m" "tzinfo"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0283wk1zxb76lg79dk501kcf5xy9h25qiw15m86s4nrfv11vqns5";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  annotate = {
    dependencies = ["activerecord" "rake"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lw0fxb5mirsdp3bp20gjyvs7clvi19jbxnrm2ihm20kzfhvlqcs";
      type = "gem";
    };
    version = "3.2.0";
  };
  ast = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      type = "gem";
    };
    version = "2.4.2";
  };
  base64 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16a0g2q40biv93i1hch3gw8rbmhp77qnnifj1k0a6m7dng3zh444";
      type = "gem";
    };
    version = "3.1.20";
  };
  bigdecimal = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gi7zqgmqwi5lizggs1jhc3zlwaqayy9rx2ah80sxy24bbnng558";
      type = "gem";
    };
    version = "3.1.8";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1srlq3gqirzdkhv12ljpnp5cb0f8jfrl3n8xs9iivyz2c7khvdyp";
      type = "gem";
    };
    version = "1.18.3";
  };
  builder = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  case_transform = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzyws6spn5arqf6q604dh9mrj84a36k5hsc8z7jgcpfvhc49bg2";
      type = "gem";
    };
    version = "0.2";
  };
  codecov = {
    dependencies = ["simplecov"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pi2dmqxjw5wsn65yx5qz5ks5msqflj0zxvk11r3cxwgacvj3hys";
      type = "gem";
    };
    version = "0.6.0";
  };
  concurrent-ruby = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0skwdasxq7mnlcccn6aqabl7n9r3jd7k19ryzlzzip64cn4x572g";
      type = "gem";
    };
    version = "1.3.3";
  };
  connection_pool = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x32mcpm2cl5492kd6lbjbaf17qsssmpx9kdyr7z1wcif2cwyh0g";
      type = "gem";
    };
    version = "2.4.1";
  };
  crass = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  date = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "149jknsq999gnhy865n33fkk22s0r447k76x9pmcnnwldfv2q7wp";
      type = "gem";
    };
    version = "3.3.4";
  };
  debug = {
    dependencies = ["irb" "reline"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z77qyzcmvz3ciny6cb24s79a243jqkybqk30b310yichp02dq28";
      type = "gem";
    };
    version = "1.9.2";
  };
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxqxgq71rqwj1lpl9q1mbhhhhhhdkkj7my341f2889pwayk85sz";
      type = "gem";
    };
    version = "1.4.0";
  };
  drb = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h5kbj9hvg5hb3c7l425zpds0vb42phvln2knab8nmazg2zp5m79";
      type = "gem";
    };
    version = "2.2.1";
  };
  erubi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qnd6ff4az22ysnmni3730c41b979xinilahzg86bn7gv93ip9pw";
      type = "gem";
    };
    version = "1.13.0";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r6zylqjfv0xhdxvldr0kgmnglm57nm506pcm6085f0xqa68cvnj";
      type = "gem";
    };
    version = "1.2.11";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1glq677vmd3xrdilcx6ar8sdaysm9ldrppg34yzw43jzr6dx47fp";
      type = "gem";
    };
    version = "6.4.5";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j6w4rr2cb5wng9yrn2ya9k40q52m0pbz47kzw8xrwqg3jncwwza";
      type = "gem";
    };
    version = "6.4.3";
  };
  faker = {
    dependencies = ["i18n"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xj0xx2snnxzjipxpxwiki7053441jkdg10h0rmjiri040s5lssi";
      type = "gem";
    };
    version = "3.4.2";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07139870npj59jnl8vmk39ja3gdk3fb5z9vc0lf32y2h891hwqsi";
      type = "gem";
    };
    version = "1.17.0";
  };
  fugit = {
    dependencies = ["et-orbi" "raabro"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f8b8qxxvkn96p89yqr8i22whnv47bg99h5s3lfr448n0g9rrp5d";
      type = "gem";
    };
    version = "1.11.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sbw6b66r7cwdx3jhs46s4lr991969hvigkjpbdl7y3i31qpdgvh";
      type = "gem";
    };
    version = "1.2.1";
  };
  good_job = {
    dependencies = ["activejob" "activerecord" "concurrent-ruby" "fugit" "railties" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zddqnrsrlqj6n23l4dmhljqfcxla840qzlcsffj3bhjjs17cn22";
      type = "gem";
    };
    version = "4.1.1";
  };
  has_scope = {
    dependencies = ["actionpack" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m2s29nzwwg26scxjwz2b2mvrfrpvb0v6q70xp9mbkdfhkb57ka8";
      type = "gem";
    };
    version = "0.8.2";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ffix518y7976qih9k1lgnc17i3v6yrlh0a3mckpxdb4wc2vrp16";
      type = "gem";
    };
    version = "1.14.5";
  };
  image_processing = {
    dependencies = ["mini_magick" "ruby-vips"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rfxkhfsqz0bj2p32yb6kv7xibair2fn240bh2j1cfsp0wkzxkvi";
      type = "gem";
    };
    version = "1.13.0";
  };
  io-console = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08d2lx42pa8jjav0lcjbzfzmw61b8imxr9041pva8xzqabrczp7h";
      type = "gem";
    };
    version = "0.7.2";
  };
  irb = {
    dependencies = ["rdoc" "reline"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05g6vpz3997q4j3xhrliswfx3g5flsn5cfn1p1s4h6dx7c0hbn2k";
      type = "gem";
    };
    version = "1.14.0";
  };
  json = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b4qsi8gay7ncmigr0pnbxyb17y3h8kavdyhsh7nrlqwr35vb60q";
      type = "gem";
    };
    version = "2.7.2";
  };
  jsonapi-renderer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ys4drd0k9rw5ixf8n8fx8v0pjh792w4myh0cpdspd317l1lpi5m";
      type = "gem";
    };
    version = "0.2.2";
  };
  language_server-protocol = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gvb1j8xsqxms9mww01rmdl78zkd72zgxaap56bhv8j45z05hp1x";
      type = "gem";
    };
    version = "3.17.0.3";
  };
  logger = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpg8gzi0xwymw4aaq2iafcbx31i3xzkg3fb30mdxn1d4qhc3dqa";
      type = "gem";
    };
    version = "1.6.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkjqf37v2d7s11176cb35cl83wls5gm3adnfkn2zcc61h3nxmqh";
      type = "gem";
    };
    version = "2.22.0";
  };
  mail = {
    dependencies = ["mini_mime" "net-imap" "net-pop" "net-smtp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bf9pysw1jfgynv692hhaycfxa8ckay1gjw5hz3madrbrynryfzc";
      type = "gem";
    };
    version = "2.8.1";
  };
  marcel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190n2mk8m1l708kr88fh6mip9sdsh339d2s6sgrik3sbnvz4jmhd";
      type = "gem";
    };
    version = "1.0.4";
  };
  mini_magick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nfxjpmka12ihbwd87d5k2hh7d2pv3aq95x0l2lh8gca1s72bmki";
      type = "gem";
    };
    version = "4.13.2";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q1f2sdw3y3y9mnym9dhjgsjr72sq975cfg5c4yx7gwv8nmzbvhk";
      type = "gem";
    };
    version = "2.8.7";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jj629q3vw5yn90q4di4dyb87pil4a8qfm2srhgy5nc8j2n33v1i";
      type = "gem";
    };
    version = "5.24.1";
  };
  mocha = {
    dependencies = ["ruby2_keywords"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04k1k9cmdv7q2p1b2z2y1k9dn1hhwjdlwkrp46gfq84v7887xhdl";
      type = "gem";
    };
    version = "2.4.5";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a5adcb7bwan09mqhj3wi9ib52hmdzmqg7q08pggn3adibyn5asr";
      type = "gem";
    };
    version = "1.7.2";
  };
  mutex_m = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ma093ayps1m92q845hmpk0dmadicvifkbf05rpq9pifhin0rvxn";
      type = "gem";
    };
    version = "0.2.0";
  };
  net-imap = {
    dependencies = ["date" "net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18yclv06n0cy8jqmi11sd1dl8nasc5n5r1mhan2v51j7jd3z58v3";
      type = "gem";
    };
    version = "0.4.12";
  };
  net-pop = {
    dependencies = ["net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = ["timeout"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = ["net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0amlhz8fhnjfmsiqcjajip57ici2xhw089x7zqyhpk51drg43h2z";
      type = "gem";
    };
    version = "0.5.0";
  };
  nio4r = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "017nbw87dpr4wyk81cgj8kxkxqgsgblrkxnmmadc77cg9gflrfal";
      type = "gem";
    };
    version = "2.7.3";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15gysw8rassqgdq3kwgl4mhqmrgh7nk2qvrcqp4ijyqazgywn6gq";
      type = "gem";
    };
    version = "1.16.7";
  };
  parallel = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "145bn5q7ysnjj02jdf1x4nc1f0xxrv7ihgz9yr1j7sinmawqkq0j";
      type = "gem";
    };
    version = "1.25.1";
  };
  parser = {
    dependencies = ["ast" "racc"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10ly2wind06nylyqa5724ld2l0l46d3ag4fm04ifjgw7qdlpf94d";
      type = "gem";
    };
    version = "3.3.4.0";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09rls4zb0vkgf80v0h4vbjr2g739gix6l1w80959d2xcb9pdi9q7";
      type = "gem";
    };
    version = "1.5.7";
  };
  prism = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05j9bcxdz6wfnrjn32zvdwj1qsbp88mwx3rv7g256gziya6avc2r";
      type = "gem";
    };
    version = "0.30.0";
  };
  psych = {
    dependencies = ["stringio"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s5383m6004q76xm3lb732bp4sjzb6mxb6rbgn129gy2izsj4wrk";
      type = "gem";
    };
    version = "5.1.2";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i2vaww6qcazj0ywva1plmjnj6rk23b01szswc5jhcq7s2cikd1y";
      type = "gem";
    };
    version = "6.4.2";
  };
  pundit = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18vz32n5ca5j5h971axnnfa8rjrfqnqv0zkgjv8xmbpb05c9m83w";
      type = "gem";
    };
    version = "2.3.2";
  };
  raabro = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10m8bln9d00dwzjil1k42i5r7l82x25ysbi45fwyv4932zsrzynl";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12z55b90vvr4sh93az2yfr3fg91jivsag8lcg0k360d99vdq568f";
      type = "gem";
    };
    version = "3.1.7";
  };
  rack-cors = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ysmn14pdf2wyr7agm0qvvr9pzcgyf39w4yvk2n05w9k4alwpa1";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-session = {
    dependencies = ["rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10afdpmy9kh0qva96slcyc59j4gkk9av8ilh58cnj0qq7q3b416v";
      type = "gem";
    };
    version = "2.0.0";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ysx29gk9k14a14zsp5a8czys140wacvp91fja8xcja0j1hzqq8c";
      type = "gem";
    };
    version = "2.1.0";
  };
  rackup = {
    dependencies = ["rack" "webrick"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbcka30g681cqasw47pq93fxjscq7yvs5zf8lp3740rb158ijvf";
      type = "gem";
    };
    version = "2.1.0";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bd6b970kwz9l23ffwg77n424gyhqqm31f493vf43rjfyyfwlzrs";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "minitest" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fx9dx1ag0s1lr6lfr34lbx5i1bvn3bhyf3w3mx6h7yz90p725g5";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pm4z853nyz1bhhqr7fzl44alnx4bjachcr6rh6qjj375sfz3sc6";
      type = "gem";
    };
    version = "1.6.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "irb" "rackup" "rake" "thor" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z0slb2dlwrwgqijbk37hl4r9bh4h8vzcyswz6a9srl8lzrljq3c";
      type = "gem";
    };
    version = "7.1.3.4";
  };
  rainbow = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  rbs = {
    dependencies = ["logger"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fzk0a3d68fglnkwpaz07npi929y1kh2hh1j63y04943vvshyjmc";
      type = "gem";
    };
    version = "3.5.2";
  };
  rdoc = {
    dependencies = ["psych"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ygk2zk0ky3d88v3ll7qh6xqvbvw5jin0hqdi1xkv1dhaw7myzdi";
      type = "gem";
    };
    version = "6.7.0";
  };
  regexp_parser = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ik40vcv7mqigsfpqpca36hpmnx0536xa825ai5qlkv3mmkyf9ss";
      type = "gem";
    };
    version = "2.9.2";
  };
  reline = {
    dependencies = ["io-console"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y6kyz7kcilwdpfy3saqfgnar38vr5ys9sp40ndffy6h1znxfbax";
      type = "gem";
    };
    version = "0.5.9";
  };
  rexml = {
    dependencies = ["strscan"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lavf9ki8ji8q3gd79b1slbxvbky4pvwb7i9g19lgy3id8kpd4ga";
      type = "gem";
    };
    version = "3.3.4";
  };
  rubocop = {
    dependencies = ["json" "language_server-protocol" "parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13bif1z20kqq8aaglj7352qpfkzbd8p8rd7lak335szxziqrn8rs";
      type = "gem";
    };
    version = "1.65.1";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "063qgvqbyv354icl2sgx758z22wzq38hd9skc3n96sbpv0cdc1qv";
      type = "gem";
    };
    version = "1.31.3";
  };
  rubocop-factory_bot = {
    dependencies = ["rubocop"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aljadsjx7affcarzbhz7pydpy6fgqb8hl951y0cmrffxpa3rqcd";
      type = "gem";
    };
    version = "2.26.1";
  };
  rubocop-minitest = {
    dependencies = ["rubocop" "rubocop-ast"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04kaagza5i4xx2pw5ybbvfxllbznr84wl7pwapc4cbi1lqqadl5g";
      type = "gem";
    };
    version = "0.35.1";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop" "rubocop-ast"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19g6m8ladix1dq8darrqnhbj6n3cgp2ivxnh48yj3nrgw0z97229";
      type = "gem";
    };
    version = "2.25.1";
  };
  ruby-lsp = {
    dependencies = ["language_server-protocol" "prism" "rbs" "sorbet-runtime"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jiz0mzdvhkp9bj1yzpx7ykwb363n2mx5y204l8ksphqn403m528";
      type = "gem";
    };
    version = "0.17.11";
  };
  ruby-progressbar = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby-vips = {
    dependencies = ["ffi" "logger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nyxwib3y2fc1lciaac0s03y3i915kyfq1kn9m19hyl5yblyhnxg";
      type = "gem";
    };
    version = "2.2.2";
  };
  ruby2_keywords = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html" "simplecov_json_formatter"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrv046jll6ad1s964gsmcq4hvkr3zzr6jc7z1mns22mvfpbc3cr";
      type = "gem";
    };
    version = "0.21.2";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx01bxa8pbf9ip4hagqkp5m0mqfnwnw2xk8kjraiywz4lrss6jb";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov_json_formatter = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19r15hyvh52jx7fmsrcflb58xh8l7l0zx4sxkh3hqzhq68y81pjl";
      type = "gem";
    };
    version = "0.1.3";
  };
  sorbet-runtime = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03iqgsnks89vc4xbaqyv96483qprqd5kdaajzvjyv3jnwslgmc5g";
      type = "gem";
    };
    version = "0.5.11505";
  };
  stringio = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07mfqb40b2wh53k33h91zva78f9zwcdnl85jiq74wnaw2wa6wiak";
      type = "gem";
    };
    version = "3.1.1";
  };
  strscan = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mamrl7pxacbc79ny5hzmakc9grbjysm3yy6119ppgsg44fsif01";
      type = "gem";
    };
    version = "3.1.0";
  };
  thor = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq1fjp45az9hfp6fxljhdrkv75cvbab1jfrwcw738pnsiqk8zps";
      type = "gem";
    };
    version = "1.3.1";
  };
  timeout = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16mvvsmx90023wrhf8dxc1lpqh0m8alk65shb7xcya6a9gflw7vg";
      type = "gem";
    };
    version = "0.4.1";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  unicode-display_width = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d0azx233nags5jx3fqyr23qa2rhgzbhv8pxp46dgbg1mpf82xky";
      type = "gem";
    };
    version = "2.5.0";
  };
  wahwah = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lgzisbcxqzar4nynmdpjzkihdjmllyc2i8wb9vlmhaiy8z20hav";
      type = "gem";
    };
    version = "1.6.2";
  };
  webrick = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nyh873w4lvahcl8kzbjfca26656d5c6z3md4sbqg5y1gfz0157n";
      type = "gem";
    };
    version = "0.7.6";
  };
  websocket-extensions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  will_paginate = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fbmm0amshidnw0qx0nqjzfyy7if8xy6m5bm8lkksf8xprp24yqh";
      type = "gem";
    };
    version = "4.0.1";
  };
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b1azc3qlyzlnld4d5yav9j13dlqlyygnml5qf4gqpzaj861d588";
      type = "gem";
    };
    version = "2.6.17";
  };
}
