<template>

    <form ref="<#table_name_kebabcase#>-form-create" v-on:keyup.enter="executeCreate(model)" novalidate>

        <div class="row">
            <#start foreach_table_column#>
            <#start if_column_data_type(String)#>
            <div class="form-group col-md-6">
                <label for="<#table_column_name_camelcase#>"><#table_column_name_formated#></label>
                <input type="text" class="form-control form-control-alternative" name="<#table_column_name_camelcase#>" placeholder="<#table_column_name_formated#>" v-model="model.<#table_column_name_camelcase#>" <#table_column_is_nullable (;required)#> />
            </div>
            <#end if_column_data_type#>
            <#start if_column_data_type(Number)#>
            <div class="form-group col-md-6">
                <label for="<#table_column_name_camelcase#>"><#table_column_name_formated#></label>
                <input type="tel" class="form-control form-control-alternative" name="<#table_column_name_camelcase#>" placeholder="<#table_column_name_formated#>" v-model="model.<#table_column_name_camelcase#>" <#table_column_is_nullable (;required)#> />
            </div>
            <#end if_column_data_type#>
            <#start if_column_data_type(Date)#>
            <div class="form-group col-md-6">
                <label for="<#table_column_name_camelcase#>Start"><#table_column_name_formated#> de</label>
                <datepicker name="<#table_column_name_camelcase#>Start" :clear-button="true" v-model="model.<#table_column_name_camelcase#>Start" input-class="form-control form-control-alternative" placeholder="dd/mm/yyyy" :language="datepicker_lang" :format="datepicker_format" <#table_column_is_nullable (;required)#> />
            </div>
            <div class="form-group col-md-6">
                <label for="<#table_column_name_camelcase#>End"><#table_column_name_formated#> até</label>
                <datepicker name="<#table_column_name_camelcase#>End" :clear-button="true" v-model="model.<#table_column_name_camelcase#>End" input-class="form-control form-control-alternative" placeholder="dd/mm/yyyy" :language="datepicker_lang" :format="datepicker_format" <#table_column_is_nullable (;required)#> />
            </div>
            <#end if_column_data_type#>
            <#start if_column_data_type(Boolean)#>
            <div class="form-group col-md-6">
                <label for="<#table_column_name_camelcase#>"><#table_column_name_formated#></label>
                <span class="clearfix"></span>
                <label class="custom-toggle">
                    <input type="checkbox" name="<#table_column_name_camelcase#>" v-model="model.<#table_column_name_camelcase#>">
                    <span class="custom-toggle-slider rounded-circle"></span>
                </label>
            </div>
            <#end if_column_data_type#>
            <#end foreach_table_column#>
        </div>

        <button type="button" class="btn btn-outline-default" @click="onBack()">
            <span><i class="fas fa-arrow-left"></i> Voltar</span>
        </button>
        <button type="button" class="btn btn-success float-right" @click="executeCreate(model)">
            <span><i class="fas fa-save"></i> Salvar</span>
        </button>

    </form>

</template>
<script>
    
    import base from '@/common/mixins/base.js'
    import Api from '@/common/api'

    export default {
        name: "<#table_name_kebabcase#>-form-create",
        mixins: [base],
        data: () => ({
            model: {},
        }),
		
        methods: {

            executeCreate(model) {

                if (this.formValidate('<#table_name_kebabcase#>-form-create') == false)
                    return;

                this.showLoading();
                
                new Api('<#table_name_lowercase#>').post(model).then(_result => {
                    this.$emit('on-saved', _result)
                    this.defaultSuccessResult();
                    this.hideLoading();
                }, err => {
                    this.defaultErrorResult(err);
                    this.hideLoading();
                })
            },

            onBack() {
                this.$emit('on-back')
            }
        },
    };
</script>

