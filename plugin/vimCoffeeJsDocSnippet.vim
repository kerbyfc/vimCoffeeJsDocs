" CoffeeScript doc snippet
"
let g:coffee_doc_mapping=',/'
let g:coffee_doc_params_pattern='\([$a-zA-Z_0-9]\+\)[, ]*\(.*\)'
let g:coffee_doc_func_pattern='->\|=>'

function! CoffeeDocSnippetExpand()
    let l    = line('.') + 1
    let placeHolderCount = 2
    let text = getline(l)
    let params   = matchstr(text,'([^)]*)')
    if match(text, g:coffee_doc_func_pattern) != -1
      let vars = []
      let m    = ' '
      let ml = matchlist(params,g:coffee_doc_params_pattern)
      while ml!=[]
        let [_,var;rest]= ml
        let vars += ['# @param '.var.' {${'.placeHolderCount.':varType}} ${'.(placeHolderCount+1).':Description}']
        let placeHolderCount = placeHolderCount+2
        let ml = matchlist(rest,g:coffee_doc_params_pattern,0)
      endwhile

      let beforeReturn = join(['###'] + vars, "\n# ${1:summary}\n")
      let retLine = "\n# ${".placeHolderCount.":@return {${".(placeHolderCount+1).":void}} ${".(placeHolderCount+2).":description}}\n"
      let comment = beforeReturn.retLine."###"
      " echoerr join(comment, "_")
      return comment
    else
      return "# $0"
    endif
endfunction

if exists('g:coffee_doc_mapping')
  execute 'inoremap <silent> ' . g:coffee_doc_mapping . " {<C-R>=UltiSnips#Anon(CoffeeDocSnippetExpand(), '{')<cr>"
endif
