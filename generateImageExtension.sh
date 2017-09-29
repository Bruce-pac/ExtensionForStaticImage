#!/bin/bash

# Generate UIImage extension for images assets

#放在和xcassets文件一个目录下，bash xx.sh xx.xcassets

if [ $# -eq 0 ]; then  #判断参数的个数是否为零，参数为手动指明的(不包括默认)
   echo "Usage: ./ios_static_images.sh path_to_images_assets"
   exit
fi

if [ ! -d $1 ]; then  #不给参数$1默认为根目录
   echo "Usage: ./ios_static_images.sh path_to_images_assets"
   exit
fi

touch imageExtension.swift

echo "extension UIImage {" >> imageExtension.swift
echo "" >> imageExtension.swift 

ls -l -R $1 | \
grep imageset | \
awk '{ print $9; }' | \
awk -F"." '{ print $1; }' | \
awk -F"_" '{ \
    out = $0" "; \
    for (i = 1; i <= NF; i++) { \
        if (i == 1) { \
            out = $i; \
        } else { \
            out = out""toupper(substr($i,1,1))substr($i,2); \
        } \
    }; \
    print out \
}' | \
sort | uniq | \
awk '{ \
    print "    static var xxx_" $2 ": UIImage {"; \
    print "        return UIImage(named: \"" $1 "\")!"; \
    print "    }\n"; \
}' >> imageExtension.swift

echo "}" >> imageExtension.swift
