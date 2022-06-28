<template>

    <div>

        <div class="container-fluid">

            <div class="row">
                <div class="col">
                    <div class="card shadow">
                        <div class="card-header border-0">
                            <div class="row">
                                <div class="col-xl-6">
                                    <h2>
                                        <i class="fas fa-cogs"></i>
                                        <#table_name_formated#>
                                    </h2>
                                </div>
                                <div class="col-xl-6 text-right">
                                    <div class="btn-group">
                                        <button class="btn btn-outline-default" @click="$router.back()"><i class="fas fa-arrow-left"></i> Voltar</button>
                                        <button class="btn btn-primary" @click="openFilter()"><i class="fas fa-filter"></i> Filtros</button>
                                        <!--<button class="btn btn-default" @click="openCreate()"><i class="far fa-file-excel"></i> Export</button>-->
                                        <button class="btn btn-success" @click="openCreate()"><i class="fas fa-plus"></i> Cadastrar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body" v-show="dialogFilter">
                            <form v-on:keyup.enter="executeFilter(filter)">
                                <div class="row">
                                    <#start foreach_table_column#>
                                    <#start if_column_data_type(String;Number)#>
                                    <div class="form-group col-md-6">
                                        <label for="<#table_column_name_camelcase#>"><#table_column_name_formated#></label>
                                        <input type="text" class="form-control form-control-alternative" name="<#table_column_name_camelcase#>" placeholder="<#table_column_name_formated#>" v-model="filter.<#table_column_name_camelcase#>" />
                                    </div>
                                    <#end if_column_data_type#>
                                    <#start if_column_data_type(Date)#>
                                    <div class="form-group col-md-6">
                                        <label for="<#table_column_name_camelcase#>Start"><#table_column_name_formated#> de</label>
                                        <datepicker name="<#table_column_name_camelcase#>Start" :clear-button="true" v-model="filter.<#table_column_name_camelcase#>Start" input-class="form-control form-control-alternative" placeholder="dd/mm/yyyy" :language="datepicker_lang" :format="datepicker_format" />
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="<#table_column_name_camelcase#>End"><#table_column_name_formated#> até</label>
                                        <datepicker name="<#table_column_name_camelcase#>End" :clear-button="true" v-model="filter.<#table_column_name_camelcase#>End" input-class="form-control form-control-alternative" placeholder="dd/mm/yyyy" :language="datepicker_lang" :format="datepicker_format" />
                                    </div>
                                    <#end if_column_data_type#>
                                    <#start if_column_data_type(Boolean)#>
                                    <div class="form-group col-md-6">
                                        <label for="<#table_column_name_camelcase#>"><#table_column_name_formated#></label>
                                        <select class="form-control form-control-alternative" v-model="filter.<#table_column_name_camelcase#>">
                                            <option value="undefined">Todos</option>
                                            <option value="true">Somente <#table_column_name_formated#></option>
                                            <option value="false">Não <#table_column_name_formated#></option>
                                        </select>
                                    </div>
                                    <#end if_column_data_type#>
                                    <#end foreach_table_column#>
                                </div>
                                <div class="text-right">
                                    <button type="button" class="btn btn-secondary" @click="executeFilter(filter)"><i class="fas fa-search"></i> Buscar</button>
                                </div>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-items-center table-flush table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th class="text-center" width="150"><i class="fa fa-cog"></i></th>
                                        <#start foreach_table_column#>
                                        <th><#table_column_name_formated#> <i @click="executeOrderBy('<#table_column_name_camelcase#>')" class="fa fa-sort"></i></th>
                                        <#end foreach_table_column#>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in result.items" v-bind:key="item.<#table_primary_key_camelcase#>" class="animated fadeIn">
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-primary" @click="openEdit({ <#table_primary_key_camelcase#>: item.<#table_primary_key_camelcase#> })">
                                                <i class="far fa-edit"></i>
                                            </button>
                                            <button type="button" class="btn btn-sm btn-danger" @click="openRemove({ <#table_primary_key_camelcase#>: item.<#table_primary_key_camelcase#> })">
                                                <i class="far fa-trash-alt"></i>
                                            </button>
                                        </td>
                                        <#start foreach_table_column#>
                                        <#start if_column_data_type(String;Number)#>
                                        <td>{{ item.<#table_column_name_camelcase#> }}</td>
                                        <#end if_column_data_type#>
                                        <#start if_column_data_type(Date)#>
                                        <td>{{ (new Date(item.<#table_column_name_camelcase#> )) | date('dd/MM/yyyy') }}</td>
                                        <#end if_column_data_type#>
                                        <#start if_column_data_type(Boolean)#>
                                        <td>
                                            <span class="badge badge-pill" v-bind:class="{ 'badge-success': item.<#table_column_name_camelcase#>, 'badge-danger': !item.<#table_column_name_camelcase#> }">
                                                {{ item.<#table_column_name_camelcase#> ? 'Sim' : 'Não' }}
                                            </span>
                                        </td>
                                        <#end if_column_data_type#>
                                        <#end foreach_table_column#>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="card-footer py-4">
                            <div class="card-block no-padding">
                                <pagination :total="result.total" :page-size="filter.pageSize" :callback="executePageChanged"></pagination>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <b-modal :no-close-on-backdrop="true" :no-close-on-esc="true" centered v-model="dialogCreate" size="lg" :hide-footer="true" title="Cadastrar">
            <form-create v-if="dialogCreate" @on-saved="onSaved()" @on-back="hideAll()" />
        </b-modal>

        <b-modal :no-close-on-backdrop="true" :no-close-on-esc="true" centered v-model="dialogEdit" size="lg" :hide-footer="true" title="Editar">
            <form-edit v-if="dialogEdit" :id="<#table_primary_key_camelcase#>" @on-saved="onSaved()" @on-back="hideAll()" />
        </b-modal>

        <b-modal :no-close-on-backdrop="true" :no-close-on-esc="true" centered v-model="dialogRemove" title="Confirmação">
            <p>Tem certeza que deseja remover este registro?</p>
            <template slot="modal-footer">
                <button class="btn btn-danger btn-block" @click="executeRemove()">
                    <i class="far fa-trash-alt"></i>
                    Remover
                </button>
            </template>
        </b-modal>

    </div>

</template>

<script>

    import base from '@/common/mixins/base.js'
    import Api from '@/common/api'

    import formCreate from './<#table_name_kebabcase#>-form-create'
    import formEdit from './<#table_name_kebabcase#>-form-edit'
    
    export default {
        name: '<#table_name_kebabcase#>',
        mixins: [base],
        components: { formCreate, formEdit },
        data() {
            return {

				dialogRemove: false,
                dialogCreate: false,
                dialogEdit: false,
                dialogFilter: false,

                model: {},
				<#table_primary_key_camelcase#>: null,

                filter: {
                    pageSize: 50,
                    pageIndex: 1,
                    isPagination: true,
                },

                result: {
                    total: 0,
                    items: []
                }
            }
        },

		methods: {
            openFilter() {
                this.dialogFilter = !this.dialogFilter;
            },
            openEdit(model) {
                this.<#table_primary_key_camelcase#> = model.<#table_primary_key_camelcase#>;
                this.dialogEdit = true;
            },
            openCreate() {
                this.dialogCreate = true;
            },
            onSaved() {
                this.hideAll();
                this.executeLoad();
            },
            hideAll() {
                this.dialogCreate = false;
                this.dialogEdit = false;
                this.dialogRemove = false;
            },

            openRemove(model) {
                this.dialogRemove = true;
                this.model = model;
            },
            executeRemove(model) {
                if (model) this.model = model;
                this.showLoading();
                new Api('<#table_name_lowercase#>').delete(this.model).then(() => {
                    this.defaultSuccessResult();
                    this.hideAll();
                    this.hideLoading();
                    this.executeLoad();
                }, err => {
                    this.hideLoading();
                    this.defaultErrorResult(err);
                })
            },

            executeFilter(filter) {
                if (filter) this.filter = filter;
                this.hideAll();
                this.executeLoad();
            },
            executePageChanged(index) {
                this.filter = this.defaultPageChanged(this.filter, index);
                this.executeLoad();
            },
            executeOrderBy(field) {
                this.filter = this.defaultOrderBy(this.filter, field);
                this.executeLoad();
            },
            executeLoad() {
                this.showLoading();
                new Api('<#table_name_lowercase#>').get(this.filter).then(_result => {
                    if (_result.summary) this.result.total = _result.summary.total;
                    this.result.items = _result.data;
                    this.hideLoading();
                }, (err) => {
                    this.hideLoading();
                    this.defaultErrorResult(err);
                });
            },

        },
        mounted() {
            this.executeFilter();
        }
    };
</script>
