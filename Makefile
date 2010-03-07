all: ChangeLog

ChangeLog: .hg/dirstate
	hg log --template='Revision: http://fuseyism.com/hg/scripts/{node|short}\n{desc}\n\n' > ChangeLog
