using <#context_name_space#>.<#context_module#>.Repository.Entities;
using <#context_name_space#>.<#context_module#>.Repository.Filters;

namespace <#context_name_space#>.<#context_module#>.Repository.Repositories
{
    public static class <#table_name#>WhereExtension
    {
        public static IQueryable<<#table_name#>> WhereDefault(this IQueryable<<#table_name#>> query, <#table_name#>Filter filter)
        {
    <#start foreach_table_column#>  
        <#start if_column_data_type(string)#>
            if (filter.<#table_column_name#>.IsSent())
                query = query.Where(_ => _.<#table_column_name#>.Contains(filter.<#table_column_name#>));
                
        <#end if_column_data_type#>

        <#start if_column_data_type(Guid;DateTime;Int64;int;Byte;decimal)#>
            if (filter.<#table_column_name#>.IsSent())
                query = query.Where(_ => _.<#table_column_name#> == filter.<#table_column_name#>);
                
        <#end if_column_data_type#>
    <#end foreach_table_column#>

            return query;
        }
    }
}

