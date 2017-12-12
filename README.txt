Демонстрация необходимости завершать Observable для освобождения ресурсов.

* Открыть AppDelegate
* Найти в SaleCardModule.deinit resultSubject.onCompleted()
* Найти MapSink, FilterSink в RxSwift и поставить в deinit брейкпоинты
* Запустить с закомменченной resultSubject.onCompleted()
* Запустить с раскомменченной resultSubject.onCompleted()
* Сравнить

Каждая подписка на оператор удерживает свой родительский observable и свой observer.
Подписка разрушится когда придет dispose (onComplete или onError).
Подписка вызовет у родительской подписки dispose и уберет ссылки на observable и observer у себя.

Поэтому НЕЛЬЗЯ бездумно использовать disposed(by:) на каждый запрос.
У observable нет гарантий на вызов dispose.
Любой observable, который надо ограничить по времени жизни, должен использовать takeUntil.
Для всех subject надо вызывать в deinit onComplete.
