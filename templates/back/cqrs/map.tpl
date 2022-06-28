using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using <#context_name_space#>.<#context_module#>.Repository.Entities;

namespace <#context_name_space#>.<#context_module#>.Repository.Mappings
{
    public class <#table_name#>Map : IEntityTypeConfiguration<<#table_name#>>
    {
        public void Configure(EntityTypeBuilder<<#table_name#>> builder)
        {
            builder.HasKey(c => c.<#table_primary_key_name#>);

            <#start foreach_table_column#>  
            
            builder.Property(c => c.<#table_column_name#>)
                .HasColumnName("<#table_column_name_original#>")
                .HasColumnType("<#table_column_data_type_original#>")<#table_column_is_nullable=true (|.IsRequired())#>;

            <#end foreach_table_column#>

            builder.ToTable("<#table_name#>");
        }

    }
}
