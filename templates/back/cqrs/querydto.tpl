// generated, do not change
namespace <#context_name_space#>.<#context_module#>.Dto.Query
{
    public class <#table_name#>QueryResultDto
    {
<#start foreach_table_column#>  
    <#start if_column_data_type(string)#>
        public <#table_column_data_type#> <#table_column_name#> { get; set; }
    <#end if_column_data_type#>

    <#start if_column_data_type(Guid;DateTime;Int64;int;Byte;decimal)#>
        public <#table_column_data_type#><#table_column_is_nullable=true (?|)#> <#table_column_name#> { get; set; }
    <#end if_column_data_type#>
<#end foreach_table_column#>
    }
}
