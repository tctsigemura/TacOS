all: sedit.exe

sedit: sedit.cmm buffer.cmm buffer.hmm screen.cmm screen.hmm
	cm2c -o sedit sedit.cmm buffer.cmm screen.cmm

sedit.exe: seditor.cmm buffer.cmm buffer.hmm screen.cmm screen.hmm
	cm2e -o sedit sedit.cmm screen.cmm screen.cmm

clean:
	rm -f sedit sedit.map
