# mapfish-print-tsb
This setup uses the latest mapfish print service (at time of writing version 3): https://mapfish.github.io/mapfish-print-doc/

## Configuration
Mapfish print is an extremely powerful and highly configurable service. BUT, in most instances you will only require a tiny subset of those configs. This exemplary setup reflects this.

Mapfish print consists of so called print *apps*, this docker includes a folder called apps. Every subfolder in apps is one such print application with the name of the folder coresponding to the url it can be accessed from. Each print app must include the following components (A lot of examples for setup can be found here: https://github.com/mapfish/mapfish-print/tree/master/examples/src/test/resources/examples).

### config.yaml
This is (obviously) the main config file. The values under attributes are most likely the most important bits especially when you start. Be adviced, when you are sending additional attributes to the endpoint, which are not documented in config.yaml printing will fail. To solve this simply add the additional attributes here and in report.jrxml and then simply ignore them. For complex examples for config.yaml, see link above).

### requestData.json
This documents a sample json-request to the endpoint.

### report.jrxml
This is the print layout of the report. The file can be build through Jaspersoft Studio (free after registration, https://community.jaspersoft.com/project/jaspersoft-studio) or (recommended) build it in a code editor. Completely building it in Jaspersoft Studio is a good way to start, but I personally still had to finetune the code later. So in the end i build the whole thing in code. If you look at the provided example it looks a bit overwhelming in the begining, but it is actually quite straight forward. A few points of advice:

#### Request Parameters
```xml
	<parameter name="title" class="java.lang.String"/>
```
In some examples you will also find the `<field.... />` parameter, i have not yet understood the difference, but if you use *field* make sure that when you reference the variable later on use `$F{title}` instead of `$P{title}`.
Furthermore, request parameters are always of type `java.lang.String` even if they are not (at least in my case).

#### Adding elements by hand
Don't forget to add valid `uuid`s to each element, otherwise you will receive errors.

#### Adding/Combining Parameters
```xml
<textFieldExpression><![CDATA["Seite " + $V{PAGE_NUMBER} + " von " + $V{PAGE_COUNT}]]></textFieldExpression>
```

#### Using Java Functions
```xml
<textFieldExpression><![CDATA["Erstellt am: "+new java.util.Date()]]></textFieldExpression>
```

#### Local Images
Japsersoft Studio provides various ways of referencing images, but not a local/relative path to an image. Don't worry, simply do it later in the code editor. It works fine:
```xml
<imageExpression><![CDATA["./images/logo_berlin.png"]]></imageExpression>
```

#### Top-level groups
When organising your report, you can add top-level groups under which you organize your elements. They follow specific rules. I used:
- title
- detail
- pageFooter
see also: http://www.alexander-merz.com/42.html (in German)

## Running
```bash
docker run -pYOURPORT:8080 -e TOMCAT_LOG_TYPE='json' YOURDOCKERNAME
```

## Security
Before public distribution the allowedReferers should be set, to stop unwanted requests:

```yaml
allowedReferers:
   - !hostnameMatch
     host: example.com
     allowSubDomains: true
```

see also: https://mapfish.github.io/mapfish-print-doc/configuration.html

## Running on render.com
This app is a bit more resource intensive and requires at least 1Gig of ram. The amount of ram also depends on the DPI and size of the reports. Bigger reports, higher resolution will require more ram.