using Microsoft.EntityFrameworkCore;
using <#context_name_space#>.<#context_module#>.Repository.Mappings;

namespace <#context_name_space#>.<#context_module#>.Repository.Context
{
    public sealed class DbContext<#context_module#> : DbContext
    {
        public DbContext<#context_module#>(DbContextOptions<DbContext<#context_module#>> options) 
            : base(options)
        {
            ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
            ChangeTracker.AutoDetectChangesEnabled = false;
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            <#start foreach_table#>
            modelBuilder.ApplyConfiguration(new <#table_name#>Map());
            <#end foreach_table#>

            base.OnModelCreating(modelBuilder);
        }

    }
}
