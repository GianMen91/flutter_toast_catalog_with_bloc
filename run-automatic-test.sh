VERSION_NAME=$(git describe --tags --abbrev=0)

# Use commit count to generate a progressive VERSION_CODE
VERSION_CODE=$(git rev-list --all --count)

# VERSION_NUMBER (the commit) is an hex string BUT flutter accept only number for the build number,
# so we will convert later to int and after in the dart code to hex again
VERSION_NUMBER=$(git rev-parse --short HEAD)

# Check if the directory 'automatic' does not exist
if [ ! -d "automatic" ]; then
  # Create the directory 'automatic' if it does not exist
  mkdir automatic
fi

# Check if the file './automatic/applicationtest-result.md' exists
if [ -f "./automatic/applicationtest-result.md" ]; then
  # Remove the file './automatic/applicationtest-result.md' if it exists
  rm automatic/applicationtest-result.md
fi

echo -e "\nAutomatic test started\n"

# Runs all the dart test files in the 'test' directory and its subdirectories and appends the output to 'test-result.txt'
for file in $(find test -name '*.dart'); do
  flutter test "$file" | tee -a test-result.txt
done

# Filters the content of 'test-result.txt' for lines starting with '#' or '-' and saves that output to 'automatic/applicationtest-result.md'
grep '^[#-]' test-result.txt >automatic/applicationtest-result.md

# Remove from file all the sentences that start with # followed by a number (test failed result case)
grep -v '^#[0-9]' automatic/applicationtest-result.md >temp && mv temp automatic/applicationtest-result.md

# Replaces the '##' with newline '##'
perl -i -pe 's/##/\n##/g' automatic/applicationtest-result.md

echo "- App version \"$VERSION_NAME ($VERSION_CODE)\" - commit $VERSION_NUMBER" | cat - automatic/applicationtest-result.md >temp && mv temp automatic/applicationtest-result.md

# Add the sentence Automated Application Test followed by the data and time of today to the top of 'automatic/applicationtest-result.md' file
echo '# Automated Application Test -' $(date +"%d-%m-%Y %T") | cat - automatic/applicationtest-result.md >temp && mv temp automatic/applicationtest-result.md

# Store the count of lines in the file 'automatic/applicationtest-result.md'
# that start with '- :no_entry_sign:' in the variable 'failed_test'.
failed_test=$(grep -c "^- :no_entry_sign:" automatic/applicationtest-result.md)

# Store the count of lines in the file 'automatic/applicationtest-result.md'
# that start with '- [x]' in the variable 'failed_test'.
success_test=$(grep -c "^- \[x\]" automatic/applicationtest-result.md)

total_test=$((failed_test + success_test))

printf "\n# Results \n - Total number of tests performed: %s\n - Number of success tests: %s\n - Number of failed tests: %s\n" "$total_test" "$success_test" "$failed_test" >>automatic/applicationtest-result.md

echo -e "\nAutomatic test finished"

# Removes 'test-result.txt' and opens the 'automatic' directory
rm test-result.txt

echo -e "\nThe applicationtest-result.md is stored under the automatic folder and its content is:\n"
cat automatic/applicationtest-result.md
