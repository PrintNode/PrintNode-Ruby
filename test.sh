#!/bin/bash
echo "Executing accounts_test.rb.."
sleep 1
ruby test/accounts_test.rb
echo "Executing accounts_info_test.rb"
sleep 1
ruby test/accounts_info_test.rb
echo "Executing computers_test.rb"
sleep 1
ruby test/computers_test.rb
