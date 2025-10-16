#!/bin/bash

php_ini_path='C:\tools\php83\php.ini'

echo $php_ini_path

sed -i "s/^\s*;\(extension=zip\)/\1/" "$php_ini_path"
sed -i "s/^\s*;\(extension=fileinfo\)/\1/" "$php_ini_path"
sed -i "s/^\s*;\(extension=pdo_sqlite\)/\1/" "$php_ini_path"