using Common.Core;
using Common.Validation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using <#context_name_space#>.<#context_module#>.Dto.Query;
using <#context_name_space#>.<#context_module#>.Repository.Filters;
using <#context_name_space#>.<#context_module#>.Repository.Repositories;

namespace <#context_name_space#>.<#context_module#>.Application.Queries
{
    public class <#table_name#>QueryHandler : QueryHandler,
        IRequestHandler<<#table_name#>Query, QueryListResult<<#table_name#>QueryResultDto>>
    {
        private readonly <#table_name#>Repository _<#table_name_camelcase#>Repository;

        public <#table_name#>QueryHandler(<#table_name#>Repository <#table_name_camelcase#>Repository, ValidationContract validation)
            : base(validation)
        {
            _<#table_name_camelcase#>Repository = <#table_name_camelcase#>Repository;
        }

        public async Task<QueryListResult<<#table_name#>QueryResultDto>> Handle(<#table_name#>Query request, CancellationToken cancellationToken)
        {
            var result = await _<#table_name_camelcase#>Repository.GetByFilters(new <#table_name#>Filter
            {
                <#start foreach_table_column#>  
                <#table_column_name#> = request.<#table_column_name#>,
                <#end foreach_table_column#>
            }).Select(_ => new <#table_name#>QueryResultDto
            {
                <#start foreach_table_column#>  
                <#table_column_name#> = _.<#table_column_name#>,
                <#end foreach_table_column#>
            }).ToListAsync();

            return new QueryListResult<<#table_name#>QueryResultDto>
            {
                Result = result,
                Errors = _validation.Notifications
            };
        }
    }
}
