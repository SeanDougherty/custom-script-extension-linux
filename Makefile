BINDIR=bin
BIN=custom-script-extension
BIN_ARM64=custom-script-extension-arm64
BUNDLEDIR=bundle
BUNDLE=custom-script-extension.zip
APP_DIR=/var/lib/waagent/Microsoft.Azure.Extensions.CustomScript-2.1.10

# waagent starts
# waagent gets a goalstate, which contains CSE must run w/ a certain payload

# waagent pulls this container with the cse binaries
# waagent places the config files and status files into APP_DIR so that CSE can consume 
# waagent calls the entrypoint for the container, which is `APP_DIR/bin/custom-script-shim enable`
# CSE takes over, consumes context from APP_DIR/HandlerEnvironment.json and the other metadata files/directories (i.e. APP_DIR/config)

# Unknowns (later):
# how to report back healthy state from the container to the guest agent on the host

bundle: clean binary
	@mkdir -p $(BUNDLEDIR)
	@mkdir -p $(APP_DIR)
	cp -r ./$(BINDIR) 					$(APP_DIR)
	cp -r ./misc/HandlerManifest.json 	$(APP_DIR)
	cp -r ./misc/manifest.xml 			$(APP_DIR)

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
