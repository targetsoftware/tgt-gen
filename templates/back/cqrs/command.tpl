using Common.Core;
using System.ComponentModel.DataAnnotations;

// generated, do not change
namespace <#context_name_space#>.<#context_module#>.Application.Commands
{
    public class <#table_name#>Command : Command<<#table_primary_key_data_type#>>
    {
<#start foreach_table_column#>  
    <#start if_column_data_type(string)#>
        <#table_column_is_nullable=true (|[Required(AllowEmptyStrings = false)])#>
        public <#table_column_data_type#> <#table_column_name#> { get; set; }

    <#end if_column_data_type#>

    <#start if_column_data_type(Guid;DateTime;Int64;int;Byte;decimal)#>
        <#table_column_is_nullable=true (|[Required])#>
        public <#table_column_data_type#><#table_column_is_nullable=true (?|)#> <#table_column_name#> { get; set; }
        
    <#end if_column_data_type#>
<#end foreach_table_column#>
    }
}
