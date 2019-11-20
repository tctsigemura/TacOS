all: sedit.exe

sedit: sedit.cmm buffer.cmm buffer.hmm display.cmm display.hmm
	cm2c -o sedit sedit.cmm buffer.cmm display.cmm

sedit.exe: seditor.cmm buffer.cmm buffer.hmm display.cmm display.hmm
	cm2e -o sedit sedit.cmm buffer.cmm display.cmm

clean:
	rm -f sedit sedit.map
