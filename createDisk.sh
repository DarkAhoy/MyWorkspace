# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $1
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +200M # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +18G #this will be the [SWAP] partition
  n #new partition
  p # primary partition
  3 # partiotion number 3
    # will start after [SWAP] partition
  +25G # / patiotion wiil be 25G {CHANGE THIS IN ORDER TO MAKE ROOT BIGGER}
  n #new partition
  p # primary partition
  4 # partiotion number 3
    # will start after / partition wiil be /home
    # will write until the end of the disk
  w # write the partition table
  q # and we're done
EOF