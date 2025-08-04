cd ../src/proto
erlc make_proto.erl
erl -noinput +B -eval "make_proto:start(), init:stop()"
move *.hrl ../../include
del *.beam
cd ../../script