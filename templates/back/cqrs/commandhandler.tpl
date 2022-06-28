using Common.Core;
using Common.Validation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using <#context_name_space#>.<#context_module#>.Repository.Entities;
using <#context_name_space#>.<#context_module#>.Repository.Repositories;

namespace <#context_name_space#>.<#context_module#>.Application.Commands
{
    public class <#table_name#>CommandHandler : CommandHandler, 
        IRequestHandler<<#table_name#>Command, CommandResult<<#table_primary_key_data_type#>>>
    {
        private readonly <#table_name#>Repository _<#table_name_camelcase#>Repository;

        public <#table_name#>CommandHandler(<#table_name#>Repository <#table_name_camelcase#>Repository, ValidationContract validation)
            : base(validation)
        {
            _<#table_name_camelcase#>Repository = <#table_name_camelcase#>Repository;
        }

        public async Task<CommandResult<<#table_primary_key_data_type#>>> Handle(<#table_name#>Command request, CancellationToken cancellationToken)
        {
            var <#table_name_camelcase#> = await _<#table_name_camelcase#>Repository.GetAll().Where(_ => _.<#table_primary_key_name#> == request.<#table_primary_key_name#>).SingleOrDefaultAsync();
            if (<#table_name_camelcase#> is null)
            {
                <#table_name_camelcase#> = _<#table_name_camelcase#>Repository.Add(new <#table_name#>()
                {
                    <#start foreach_table_column#>  
                    <#table_column_name#> = request.<#table_column_name#>,
                    <#end foreach_table_column#>
                });
            }
            else
            {
                <#start foreach_table_column#>  
                <#table_name_camelcase#>.<#table_column_name#> = request.<#table_column_name#>;
                <#end foreach_table_column#>
                
                _<#table_name_camelcase#>Repository.Update(<#table_name_camelcase#>);
            }

            await _<#table_name_camelcase#>Repository.Commit();

            return new CommandResult<<#table_primary_key_data_type#>>
            {
                Result = <#table_name_camelcase#>.<#table_primary_key_name#>,
                Errors = _validation.Notifications
            };
        }

    }
}
