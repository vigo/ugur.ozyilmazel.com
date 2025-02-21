![Version](https://img.shields.io/badge/version-0.1.13-orange.svg)
[![pages-build-deployment](https://github.com/vigo/ugur.ozyilmazel.com/actions/workflows/pages/pages-build-deployment/badge.svg?branch=gh-pages)](https://github.com/vigo/ugur.ozyilmazel.com/actions/workflows/pages/pages-build-deployment)

# ugur.ozyilmazel.com - V6

Kişisel web sitem...

## Rakefile

```bash
$ rake -T

rake build                                  # build pages
rake deploy[bump]                           # deploy to gh-pages with bump
rake new:page[title,language]               # new page
rake new:post[title,language,publish_date]  # new blog post
rake now                                    # print now
rake run_server                             # run server
```

Yeni post için;

```bash
rake new:post["Python\, TextMate Ne Alakası Var?"]     # virgül escape edilmeli
rake new:post["Hello World", "en"]                     # ingilizce
rake new:post["Hello World", "en","2024-05-14 21:00"]  # ingilizce + tarih
```

---

## Lisans

Bu proje MIT lisansı kullanmaktadır.
