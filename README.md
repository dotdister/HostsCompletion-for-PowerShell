HostsCompletion-for-PowerShell
================================

Complement names of hosts file in Windows PowerShell
 
 
Installation
-------------

Please download `HostsCompletion.ps1` and add 

```PowerShell
. path/to/HostsCompletion.ps1
```

to your `Profile.ps1`.

Usage
-------

If you added `127.0.0.1 localhost` to your hosts file, you can get hostnames completion.
For example, when you type 

```
ping lo
```

and press tab, you will get

```
ping localhost
```

This supports `[ ping | route | ssh | scp | ftp ]` commands in Windows PowerShell.
