//= require active_admin/base
//= require activeadmin/dynamic_fields
//= require jsoneditor

(function(window, $) {
    $(function() {
        $('div.js-jsoneditor').each(function(i, wrap){
            const textarea = $(wrap).find('input[type=hidden]')
            const fieldset = $(wrap).parents('li:eq(0)')
            const container = $(wrap)[0]
            const editor = new JSONEditor(container,
                {
                    modes: ['tree', 'text'],
                    mode: 'tree',
                    onChange: function(){
                        try {
                            const text = JSON.stringify(editor.get())
                            textarea.val(text)
                            $(fieldset).toggleClass('error',false)
                            textarea.val(JSON.stringify(editor.get()))
                        } catch (e) {
                            editor.options.error(e)
                        }
                    },
                    onError: function(e){
                        $(fieldset).toggleClass('error',true)
                    }
                },
                JSON.parse(textarea.val()))
        });
    });
})(window, jQuery);
