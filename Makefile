all: compile

compile:
	mix compile

docs:
	mix edoc

clean:
	mix clean

dialyzer: 
	mix dialyzer

test: dialyzer
	mix test
