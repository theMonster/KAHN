KAHN
====

<p align="center">
  <b>K</b>ick <b>A</b>ss <b>H</b>TTP <b>N</b/>etworking<br />
  <img align="center" src="/KHAAAAAN.gif" />
</p>

Features / TODO list:
----
- [ ] JSON endings
   - [x] GET
- [ ] Serializer
- [ ] multipart upload
- [ ] progress upload / download
- [ ] get parameters
- [ ] request closure chaining (i.e: endpoint.GET() { .. closure .. }.POST() { .. closure .. })
- [ ] request chaining (i.e: endpoint1 & endpoint2.GET(){ (responseFrom1, responseFrom2) in .. closure .. }
- [ ] request merging
- [ ] setFullURL(url:NSURL)
- [ ] validation
- [ ] .copy()
- [x] keyed urls (i.e: setEndpoint("some/url/{my_token}") my_token get's replaced with a string value provided in options)
- [ ] default value for key (i.e: setEndpoint("some/url/{my_token=somewhere}"
