<template>

    <form ref="<#table_name_kebabcase#>-form-edit" v-on:keyup.enter="executeEdit(model)" novalidate>

        <div class="row">

            <#formFields#>

        </div>

        <button type="button" class="btn btn-outline-default" @click="onBack()">
            <span><i class="fas fa-arrow-left"></i> Voltar</span>
        </button>
        <button type="button" class="btn btn-success float-right" @click="executeEdit(model)">
            <span><i class="fas fa-save"></i> Salvar</span>
        </button>

    </form>


</template>
<script>

    import base from '@/common/mixins/base.js'
    import Api from '@/common/api'

    export default {
        name: "<#table_name_kebabcase#>-form-edit",
        mixins: [base],
        props: { <#table_primary_key_camelcase#>: String },
        data: () => ({
            model: {},
        }),
		
        methods: {

            executeEdit(model) {

                if (this.formValidate('<#table_name_kebabcase#>-form-edit') == false) 
                    return;

                this.showLoading();
                
                new Api('<#table_name_lowercase#>').put(model).then(result => {
                    this.defaultSuccessResult();
                    this.$emit('on-saved', result.data)
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

        mounted() {

            this.showLoading();
                
            new Api('<#table_primary_key_camelcase#>').get({ id: this.<#table_primary_key_camelcase#> }).then(_result => {
                this.model = _result.data;
                this.hideLoading();
            }, err => {
                this.defaultErrorResult(err);
                this.hideLoading();
            })
        }
    };
</script>