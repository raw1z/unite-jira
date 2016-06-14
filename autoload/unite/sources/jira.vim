let s:Vital = vital#of('vital')
let s:Base64 = s:Vital.import('Data.Base64')

function! unite#sources#jira#define() abort "{{{
  return s:source
endfunction "}}}

let s:source = {
      \ 'name' : 'jira',
      \ 'description' : 'Jira interface for unite',
      \ 'default_kind' : 'command',
      \ 'hooks' : {},
      \}

function! s:source.gather_candidates(args, context) abort "{{{
  let user = $JIRA_USER
  let password = $JIRA_PASSWORD
  let url = 'https://unowhy2015.atlassian.net/rest/api/2/search?jql=assignee=' . user
  let params = {}
  let headers = {
        \ 'Content-Type': 'application/json',
        \ 'Authorization': 'Basic ' . s:Base64.encode(user . ':' . password)
        \ }
  let response = webapi#http#get(url, params, headers)
  let payload = json_decode(response.content)
  return map(payload.issues, 'self.build_candidate(v:val)')
endfunction "}}}
function! s:source.build_candidate(issue) abort "{{{
  return {
        \ 'word': a:issue.fields.summary
        \ }
endfunction "}}}
