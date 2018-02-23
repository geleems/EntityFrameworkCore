## Build Entity Framework Core
* Clone the repository: `https://github.com/aspnet/EntityFrameworkCore`
```
$ git clone https://github.com/aspnet/EntityFrameworkCore EFCore
```
* Build the repository using `build.cmd` or `build.sh` depending on your OS.
* Make a note of the dotnet path that is used for build. The path will be used to execute specific tests.
  * In this example, the dotnet path is `/home/gene/.dotnet/dotnet`
```
$ cd EFCore
$ ./build.sh 
Using KoreBuild 2.1.0-preview2-15707
Using cached .NET Framework reference assemblies from /home/gene/.dotnet/buildtools/netfx/4.6.1
warning: dotnet found on the system PATH is '/usr/bin/dotnet' but KoreBuild will use '/home/gene/.dotnet/dotnet'.
warning: Adding '/home/gene/.dotnet' to system PATH permanently may be required for applications like Visual Studio for Mac or VS Code to work correctly.
```

## Run SQL Server specific tests
* Path for SQL Server specific tests: `<EFCore_root>/test/EFCore.SqlServer.FunctionalTests`
* Modify the `config.json` to input connection string.
  * `config.json` path: `<EFCore_root>/test/EFCore.SqlServer.FunctionalTests/config.json`
  * It is recommended the server of the connection string is empty, and has no databases configured.
```
$ cd <EFCore_root>/test/EFCore.SqlServer.FunctionalTests
$ subl config.json
{
    "Test": {
      "SqlServer": {
        //"DefaultConnection": "Data Source=(localdb)\\MSSQLLocalDB;Database=master;Integrated Security=True;Connect Timeout=60;ConnectRetryCount=0",
        "DefaultConnection": "Data Source=<server>;User ID=<user_id>;Password=<password>;Connect Timeout=60;ConnectRetryCount=0",
        "ElasticPoolName": "",
        "SupportsSequences": true,
        "SupportsOffset": true,
        "SupportsMemoryOptimized": false,
        "SupportsHiddenColumns": true,
        "SupportsFullTextSearch": true
      }
    }
}
```
* Run all the tests: `<dotnet_path> test --framework netcoreapp2.0`
* For running specific tests, add option: `--filter="FullyQualifiedName=<NameSpace.Class.Method>"`
* For skiping build, add option: `--no-build`

```
$ cd <EFCore_root>/test/EFCore.SqlServer.FunctionalTests
$ <dotnet_path> test --framework netcoreapp2.0 --no-build --filter="FullyQualifiedName=<NameSpace.Class.Method>"
```

## Run SQL Server specific tests with your own version of SqlClient
* Build your own version of SqlClient in Release mode
  * Linux: `<corefx_root>/Tools/msbuild.sh /t:Rebuild /p:OSGroup=Unix,ConfigurationGroup=Release`
    * dll: `<CoreFx_root>/bin/Unix.AnyCPU.Release/System.Data.SqlClient/netstandard/System.Data.SqlClient.dll`
  * Windows: `msbuild /t:Rebuild /p:OSGroup=Windows_NT,ConfigurationGroup=Release`
    * dll: `<CoreFx_root>\bin\Windows_NT.AnyCPU.Release\System.Data.SqlClient\netstandard\System.Data.SqlClient.dll`
* Replace current SqlClient in nuget cache that EF tests use with your own version of SqlClient.
  * Find out what version of SqlClient is used for testing
    * Open `<EFCore_root>/build/dependencies.props`
    * Find xml tag: `<SystemDataSqlClientPackageVersion>`
```
<SystemDataSqlClientPackageVersion>4.5.0-preview2-26130-01</SystemDataSqlClientPackageVersion>
```
  * Go to SqlClient .nuget cache
    * Linux: `~/.nuget/packages/system.data.sqlclient/<SqlClientVersionFromAbove>/runtimes/unix/lib/netstandard2.0`
    * Windows: `%userprofile%\.nuget\packages\system.data.sqlclient\<SqlClientVersionFromAbove>\runtimes\unix\lib\netstandard2.0`
  * Backup current SqlClient
```
$ cd ~/.nuget/packages/system.data.sqlclient/4.5.0-preview2-26130-01/runtimes/unix/lib/netstandard2.0
$ mkdir original
$ mv System.Data.SqlClient.dll ./original/
```
  * Copy your own version of SqlClient into the SqlClient .nuget path
```
$ cp <CoreFx_root>/bin/Unix.AnyCPU.Release/System.Data.SqlClient/netstandard/System.Data.SqlClient.dll
     ~/.nuget/packages/system.data.sqlclient/<SqlClientVersionFromAbove>/runtimes/unix/lib/netstandard2.0/
```
```
> copy <CoreFx_root>\bin\Windows_NT.AnyCPU.Release\System.Data.SqlClient\netstandard\System.Data.SqlClient.dll
       %userprofile%\.nuget\packages\system.data.sqlclient\<SqlClientVersionFromAbove>\runtimes\win\lib\netstandard2.0
```
