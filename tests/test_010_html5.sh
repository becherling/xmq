#!/bin/bash

TEST=$(basename "$0" | sed 's/.sh//')
echo $TEST
XMQ="$1"
OUT="$2/$TEST"

rm -rf $OUT
mkdir -p $OUT

$XMQ tests/${TEST}.html > $OUT/out.xmq
cat > $OUT/expected.xmq <<EOF
html {
    body {
        img(alt    = icon
            width  = 15
            height = 16
            src    = 'data:image/gif;base64,R0lGODlhDwAQAIQSAAAAABoaGiYmJicnJ/8AAF9fX2JiYri4uLm5ub29vb6+vr+/v8DAwMjIyMnJycrKyuzs7O7u7v///////////////////////////////////////////////////////yH5BAEKAB8ALAAAAAAPABAAAAVNICGOZElIaKqm4uqi7bvGKuDGDwFJNkQ8sJMEUgggAIdAYSehSRIDgkChci6iA0ZVGDEEDsiAIRJENXS8IcFRXtlmQhkrLm/S5ab8KAQAOw==')
        h1 = Välkommen!
        p(info = '"\'hello\'"')
        {
            'En paragraf'
            br
            'En till paragraf'
        }
        'Ny rad'
        ol {
            li = 'Steg 1: Laborera'
            li = 'Steg 2: Acceptera'
            li = 'Steg 3: Perifiera'
            li(class = red) = 'Steg 4: Nomiera'
        }
        button(onClick = 'alert(\'Gone!\');') = 'Go go go!'
    }
}
EOF

diff $OUT/out.xmq $OUT/expected.xmq
if [ "$?" != "0" ]; then exit 1; fi

$XMQ $OUT/out.xmq > $OUT/back.xml
diff $OUT/back.xml tests/${TEST}.html
if [ "$?" != "0" ]; then exit 1; fi
