# xmq
Convert xml to a human readable/editable format and back.

| OS           | Status           |
| ------------ |:-------------:|
|GNU/Linux & MacOSX| [![Build Status](https://travis-ci.org/weetmuts/xmq.svg?branch=master)](https://travis-ci.org/weetmuts/xmq) |

Xml can be human readable/editable if it is used for markup of longer
human language texts, ie books, articles and other documents etc. In
these cases the xml-tags represent a minor part of the whole xml-file.

However xml is often used for configuration files, the most prevalent
is the pom.xml files for maven.  In such config files the xml-tags
represent a major part of the whole xml-file. This makes the config
files hard to read and edit directly by hand.

The xmq format is simply a restructuring of the xml that (to me at
least) makes config files written in xml easier to read and edit.

The xmq format reserves these 7 characters and whitespace:
```
= ' { } ( )
```
where whitespace is space,cr,lf,tab,newline. Any content containing the
reserved characters must be quoted using the single quote character.

```
purchase {
    product = 'Bar of soap'
    price   = 123.4
    date    = 2020-12-09
}
```

which translates into
```
<purchase>
  <product>Bar of soap</product>
  <price>123.4</price>
  <date>2020-12-09</date>
</purchase>
```

Xmq is designed to exactly represent the xml format and can therefore
be converted back to xml after any editing has been done.
**But caveat whitespace trimmings!**

Xmq makes significant whitespace explicit. Also contrary to xml, xmq
will by default treat leading and ending whitespace as insignificant
and trim these, but keeping incidental indentations. If you want to
preserve all whitespace then use `-p` for preserve whitespace.

Without -p, the following xml is considered by xmq to be equivalent to the above xml.
```
<purchase>
  <product>
     Bar of soap
  </product>
  <price>   123.4   </price>
  <date>
2020-12-09</date></purchase>
```

Likewside this xmq is equivalent:
```
purchase{product='Bar of soap' price=123.4 date=2020-12-09}
```

Xml forbids the reserved characters in tags and thus xmq does as well.
Content/value strings do not need to be quoted if they do not contain
the reserved characters.
```
form=27B/6
```
but
```
address='Street 123 (b)'
```

Value strings (tag content or attributes) that contain the
reserved characters must be quoted with the `'`.  A
single quote must be is typed \\' inside a quoted string.

A comment starts with `//` or `/*` and ends with eol or `*/`.
Thus a value string that starts with the comment starters,
must be quoted with the `' <SINGLE QUOTE>`.

Type `xmq pom.xml > pom.xmq` to convert your pom.xml file into an xmq file.

Make your desired changes in the xmq file and then
do `xmq pom.xmq > pom.xml` to convert it back.

You can read form stdin like this:  `cat pom.xml | xmq -`
and there is a utility to view xml files: `xmq-less pom.xml`

There is an xmq major mode for emacs in xmq-mode.el.
Put it into your `.emacs.d/site-lisp` directory and
require it `(require 'xmq-mode)` in your .emacs file.

You can also bind xmq to for example ctrl-t `(global-set-key (kbd "C-t") 'xmq-buffer)`
When you have an xml file in the buffer and you press ctrl-t, you will
switch the buffer back and forth between xmq and xml.

Do `make && sudo make install` to have xmq, xmq-less, xmq-diff, xmq-git-diff and xmq-meld
installed into /usr/local/bin.

# Terminal example

Xml to the left. Colored XMQ (using xmq-less) to the right.

![XML vs XMQ](/doc/xml_vs_xmq.png)

Multiline content is quoted:

![Multiline](/doc/multiline.png)

# Emacs example

Assuming xmq-buffer is bound to ctrl-t, pressing ctrl-t
will flip between xml and xmq as can be seen below.

![XML vs XMQ](/doc/emacs_xml_xmq.png)

# Diffing

You can diff two xml files: `xmq-diff old.xml new.xml`

You can diff an xml file against its git repo: `xmq-git-diff file.xml` or using `xmq-git-meld file.xml`

You can meld two xml files: `xmq-meld old.xml new.xml`

# Excluding attributes

You can exclude the attribute `foo` in every node: `xmq-less -x @foo foo.xml`

# Compressing

If the node names are very long and have consistent prefixes
you can compress the output: `xmq-less -c foo.xml` `xmq-git-diff -c -x @name foo.xml`

This will replace a long prefix `abc.def.ghi` with for example `0:`
depending on how many prefixes are found. The prefix is printed
at the top of the xmq file.
