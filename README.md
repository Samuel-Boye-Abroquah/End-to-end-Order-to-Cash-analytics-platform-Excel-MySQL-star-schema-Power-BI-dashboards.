# 1. See the exact filenames
git ls-files Documents/

# 2. Rename image 1 (verified from the output above)
git mv "Documents/are we growing profitably dashbaord.png" "Documents/are-we-growing-profitably-dashboard.png"

# 3. Rename image 2 (paste the exact name from step 1)
git mv "Documents/<exact name from step 1>.png" "Documents/order-fulfillment-and-operations-dashboard.png"

# 4. Commit and push
git commit -m "docs: rename dashboard screenshots to kebab-case"
git push
