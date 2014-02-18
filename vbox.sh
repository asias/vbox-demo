# Setup name and dir
name=osv8
img=osv.vdi
vmdir=~/VirtualBox\ VMs/$name

# Stop vm 
VBoxManage controlvm $name poweroff 

# Unreigster vm
VBoxManage unregistervm $name --delete 

# Create and register the vm
VBoxManage createvm  --name $name -ostype Linux26_64
VBoxManage registervm "$vmdir/$name.vbox"

# Setup SATA controller
#qemu-img convert -f raw $img -O vdi "$vmdir/$name.vdi"
cp -v $img "$vmdir/$name.vdi"
VBoxManage storagectl  $name  --name SATA --add sata --controller IntelAHCI 
VBoxManage storageattach  $name --storagectl SATA --port 0 --type hdd --medium "$vmdir/$name.vdi"

# Setup network nat
#VBoxManage modifyvm $name --nic1 nat
#VBoxManage modifyvm $name --nictype1 virtio

# Setup Network hostonly
VBoxManage modifyvm $name --nic1 hostonly
VBoxManage modifyvm $name --nictype1 virtio
VBoxManage modifyvm $name --hostonlyadapter1 vboxnet0

# Turn on HPET timer
VBoxManage modifyvm $name --hpet on

# Setup serial
VBoxManage modifyvm $name  --uart1 0x3f8 4
VBoxManage modifyvm $name  --uartmode1 file "$vmdir/$name.log"

# Start vm
#VBoxManage startvm --type gui $name
VBoxManage startvm --type headless $name

sleep 10

# Check the serial log
cat "$vmdir/$name.log"
