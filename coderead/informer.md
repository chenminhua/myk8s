Informer 的机制
cient-go 是从 k8s 代码中抽出来的一个客户端工具，Informer 是 client-go 中的核心工具包，已经被 kubernetes 中众多组件所使用。所谓 Informer，其实就是一个带有本地缓存和索引机制的、可以注册 EventHandler 的 client，本地缓存被称为 Store，索引被称为 Index。使用 informer 的目的是为了减轻 apiserver 数据交互的压力而抽象出来的一个 cache 层, 客户端对 apiserver 数据的 “读取” 和 “监听” 操作都通过本地 informer 进行。Informer 实例的Lister()方法可以直接查找缓存在本地内存中的数据。

Informer 的主要功能：

同步数据到本地缓存
根据对应的事件类型，触发事先注册好的 ResourceEventHandler