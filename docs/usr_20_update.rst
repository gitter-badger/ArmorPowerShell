Update
========================

Option 1: PowerShell Gallery Update (Recommended)
------------------------

If you installed the module via the PowerShell Gallery, please implement the following when you want to update to a newer version:

1. Open a Powershell console with the *Run as Administrator* option.
2. Run ``Update-Module -Name Armor``.

Option 2: PowerShell Gallery Download
------------------------

If you deployed a saved module via the PowerShell Gallery, please implement the following when you want to update to a newer version:

1. Open a Powershell console with the *Run as Administrator* option.
2. Run ``Save-Module -Name Armor -Path <path>`` to download the module from the PowerShell Gallery. Note that the first time you install from the remote repository it may ask you to first trust the repository. 
3. Copy the contents of the Armor module folder onto your workstation into the desired PowerShell Module path.

Option 3: Manual Installation
------------------------

If you deployed the module via download from GitHub, please implement the following when you want to update to a newer version:

1. Download the `master branch`_ to your workstation.
2. Copy the contents of the *Armor* folder onto your workstation into the desired PowerShell Module path.

.. _master branch: https://github.com/tlindsay42/ArmorPowerShell
