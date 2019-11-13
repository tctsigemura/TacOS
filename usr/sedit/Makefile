all: sedit.exe

sedit: sedit.cmm buffer.cmm buffer.hmm
	cm2c -o sedit sedit.cmm buffer.cmm

sedit.exe: sedit.cmm buffer.cmm buffer.hmm
	cm2e -o sedit sedit.cmm buffer.cmm

clean:
	rm -f sedit sedit.map
