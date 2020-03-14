use vim to pointfree your haskell functions

---

### Installation

vim-pointfree depends on
[pointfree](https://hackage.haskell.org/package/pointfree), so make sure that
it is installed and available in your $PATH.

To install using vim-plug:

```viml
Plug 'm00qek/vim-pointfree'
```

### Configuration

add something like the following on your vimrc

```viml
nnoremap <silent> <Leader>. :call pointfree#suggestions()<CR>
vnoremap <silent> <Leader>. :call pointfree#selection()<CR>
```
