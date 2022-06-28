<template>

    <div class="container-fluid mt--8">

        <div class="row">
            <div class="col">
                <div class="card shadow">
                    <div class="card-header border-0">
                        <div class="row">
                            <div class="col-xl-6">
                                <h2>
                                    <i class="fas fa-pencil"></i>
                                    Editar <#table_name_formated#>
                                </h2>
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
						<form-edit v-if="dialogEdit" :<#table_primary_key_camelcase#>="<#table_primary_key_camelcase#>" @on-saved="onSaved" @on-back="onBack()" />
                    </div>
                </div>
            </div>
        </div>
    </div>

</template>
<script>

    import formEdit from './<#table_name_kebabcase#>-form-edit'

    export default {
        name: '<#table_name_kebabcase#>-edit',
        components: { formEdit },
        data: () => ({
            dialogEdit: false,
			<#table_primary_key_camelcase#>: 0
        }),
        methods: {
            onSaved(data) {
				if (data) this.$router.push({ path: '/<#table_name_kebabcase#>' });
            },
            onBack() {
                this.$router.go(-1);
            }
        },
        mounted() {
            this.<#table_primary_key_camelcase#> = +this.$route.params.id;
            this.dialogEdit = true;
        }
    };
</script>

