using Common.Orm.Repository;
using <#context_name_space#>.<#context_module#>.Repository.Context;
using <#context_name_space#>.<#context_module#>.Repository.Entities;
using <#context_name_space#>.<#context_module#>.Repository.Filters;

namespace <#context_name_space#>.<#context_module#>.Repository.Repositories
{
    public class <#table_name#>Repository : Repository<<#table_name#>>
    {
        public <#table_name#>Repository(DbContextCore ctx)
            : base(ctx)
        {

        }

        public IQueryable<<#table_name#>> GetByFilters(<#table_name#>Filter filter)
        {
            var query = this.GetAll()
                .WhereDefault(filter);

            return query;
        }
    }
}
