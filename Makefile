BINDIR=bin
BIN=custom-script-extension
BIN_ARM64=custom-script-extension-arm64
BUNDLEDIR=bundle
BUNDLE=custom-script-extension.zip
PUBLISHER=Microsoft.Azure.Extensions
EXT_NAME=CustomScript
VERSION=2.1.10
APP_DIR=/var/lib/waagent/$(PUBLISHER).$(EXT_NAME)-$(VERSION)
#APP_DIR=/var/lib/waagent/Microsoft.Azure.Extensions.CustomScript-2.1.10

bundle: clean binary
	@mkdir -p $(BUNDLEDIR)
	@mkdir -p $(APP_DIR)
	cp -r ./$(BINDIR)                   $(APP_DIR)
	cp -r ./misc/HandlerManifest.json   $(APP_DIR)
	cp -r ./misc/manifest.xml           $(APP_DIR)

binary: clean
	if [ -z "$$GOPATH" ]; then \
	  echo "GOPATH is not set"; \
	  exit 1; \
	fi
	GOOS=linux GOARCH=amd64 go build -v \
	  -ldflags "-X main.Version=`grep -E -m 1 -o  '<Version>(.*)</Version>' misc/manifest.xml | awk -F">" '{print $$2}' | awk -F"<" '{print $$1}'`" \
	  -o $(BINDIR)/$(BIN) ./main 
	GOOS=linux GOARCH=arm64 go build -v \
	  -ldflags "-X main.Version=`grep -E -m 1 -o  '<Version>(.*)</Version>' misc/manifest.xml | awk -F">" '{print $$2}' | awk -F"<" '{print $$1}'`" \
	  -o $(BINDIR)/$(BIN_ARM64) ./main 
	cp ./misc/custom-script-shim ./$(BINDIR)
clean:
	rm -rf "$(BINDIR)" "$(BUNDLEDIR)"

.PHONY: clean binary
