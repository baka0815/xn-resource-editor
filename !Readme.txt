NOTE: Currently the sources are only compilable in Delphi 2006

To compile XNResourceEditor you need to install the prerequisites first:
* TNTComponents:
  * open .\prerequisites\TNTComponents\Delphi\bds4\Delphi2006.bdsgroup
  * build both packages
  * install the designtime package
* VirtualTreeview
  * open .\prerequisites\VirtualTreeview\Packages\BDS 2006\BDS2006.bdsgroup
  * build both packages
  * install the designtime package
* LowLevel
  * open .\prerequisites\LowLevel\Packages\Delphi2006\LowLevel.bdsproj
  * build the package
* ImageTypes
  * open .\prerequisites\ImageTypes\Packages\Delphi2006\ImageTypes.bdsproj
  * build the package
* MiscUnits
  * open .\prerequisites\MiscUnits\Packages\BDS 2006\MiscUnits.bdsproj
  * build the package
  * install it
* ResourceUtils:
  * open .\prerequisites\ResourceUtils\Packages\BDS 2006\ResourceUtils.bdsproj
  * build the package
* VirtualTreesExensions
  * open .\prerequisites\d12componentpackages\Packages\Delphi2006\VirtualTreesExensions.bdsgroup
  * build both packages
  * install the designtime package
* XN Resource Editor Components
  * open .\components\packages\Delphi2006\ResourceEditorComponents.bdsproj
  * build and install the package

You are now ready to load the XNResourceEditor project
.\source\XNResourceEditor.bdsproj
and compile it.
