// Copyright (c) 2021 Payoneer Germany GmbH
// https://www.payoneer.com
//
// This file is open source and available under the MIT license.
// See the LICENSE file for more information.

#if canImport(UIKit)
import UIKit

@objc public final class PaymentListViewController: UIViewController {
    weak var methodsTableView: UITableView?
    weak var activityIndicator: UIActivityIndicatorView?
    weak var errorAlertController: UIAlertController?

    let sessionService: PaymentSessionService
    fileprivate(set) var tableController: List.Table.Controller?
    let sharedTranslationProvider: SharedTranslationProvider
    fileprivate let router: List.Router

    public weak var delegate: PaymentDelegate?

    /// TODO: Migrate to separate State manager
    fileprivate var viewState: Load<PaymentSession, UIAlertController.AlertError> = .loading {
        didSet { changeState(to: viewState) }
    }

    lazy private(set) var slideInPresentationManager = SlideInPresentationManager()

    /// - Parameter listResultURL: URL that you receive after executing *Create new payment session request* request. Needed URL will be specified in `links.self`
    @objc public convenience init(listResultURL: URL) {
        let sharedTranslationProvider = SharedTranslationProvider()
        let connection = URLSessionConnection()

        self.init(listResultURL: listResultURL, connection: connection, sharedTranslationProvider: sharedTranslationProvider)
    }

    init(listResultURL: URL, connection: Connection, sharedTranslationProvider: SharedTranslationProvider) {
        sessionService = PaymentSessionService(paymentSessionURL: listResultURL, connection: connection, localizationProvider: sharedTranslationProvider)
        self.sharedTranslationProvider = sharedTranslationProvider
        router = List.Router(paymentServicesFactory: sessionService.paymentServicesFactory)

        super.init(nibName: nil, bundle: nil)

        sessionService.delegate = self
        router.rootViewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Overrides

extension PaymentListViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .themedBackground
        navigationItem.largeTitleDisplayMode = .never

        // If view was presented modally show Cancel button
        if navigationController == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonDidPress))
        }

        loadPaymentSession()
    }

    public override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        methodsTableView?.reloadData()
    }
}

extension PaymentListViewController {
    func loadPaymentSession() {
        viewState = .loading
        sessionService.loadPaymentSession()
    }

    fileprivate func show(paymentNetworks: [PaymentNetwork], animated: Bool) {
        do {
            let inputViewController = try router.present(paymentNetworks: paymentNetworks, animated: animated)
            inputViewController.delegate = self
        } catch {
            let errorInfo = CustomErrorInfo.createClientSideError(from: error)
            dismiss(with: .failure(errorInfo))
        }
    }

    fileprivate func show(registeredAccount: RegisteredAccount, animated: Bool) {
        do {
            let inputViewController = try router.present(registeredAccount: registeredAccount, animated: animated)
            inputViewController.delegate = self
        } catch {
            let errorInfo = CustomErrorInfo.createClientSideError(from: error)
            dismiss(with: .failure(errorInfo))
        }
    }

    @objc fileprivate func cancelButtonDidPress() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - View state management

extension PaymentListViewController {
    fileprivate func changeState(to state: Load<PaymentSession, UIAlertController.AlertError>) {
        switch state {
        case .success(let session):
            do {
                activityIndicator(isActive: false)
                try showPaymentMethods(for: session)
                dismissAlertController()
            } catch {
                let errorInfo = CustomErrorInfo.createClientSideError(from: error)
                dismiss(with: .failure(errorInfo))
            }
        case .loading:
            do {
                activityIndicator(isActive: true)
                try showPaymentMethods(for: nil)
                dismissAlertController()
            } catch {
                let errorInfo = CustomErrorInfo.createClientSideError(from: error)
                dismiss(with: .failure(errorInfo))
           }
        case .failure(let error):
            activityIndicator(isActive: true)
            try? showPaymentMethods(for: nil)
            present(error: error)
        }
    }

    private func showPaymentMethods(for session: PaymentSession?) throws {
        guard let session = session else {
            // Hide payment methods
            methodsTableView?.removeFromSuperview()
            methodsTableView = nil
            tableController = nil

            return
        }

        // Show payment methods
        let methodsTableView = addMethodsTableView(to: view)
        self.methodsTableView = methodsTableView

        let tableController = try List.Table.Controller(session: session, translationProvider: sharedTranslationProvider)
        tableController.tableView = methodsTableView
        tableController.delegate = self
        self.tableController = tableController

        methodsTableView.dataSource = tableController.dataSource
        methodsTableView.delegate = tableController
        methodsTableView.prefetchDataSource = tableController

        methodsTableView.invalidateIntrinsicContentSize()
    }

    private func activityIndicator(isActive: Bool) {
        if isActive == false {
            // Hide activity indicator
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
            return
        }

        if self.activityIndicator != nil { return }

        // Show activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.activityIndicator = activityIndicator
        activityIndicator.startAnimating()
    }

    private func dismissAlertController() {
        errorAlertController?.dismiss(animated: true, completion: nil)
    }

    private func present(error: UIAlertController.AlertError) {
        let alertController = error.createAlertController(translator: sharedTranslationProvider)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Table View UI

extension PaymentListViewController {
    fileprivate func addScrollView() -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceVertical = true
        scrollView.preservesSuperviewLayoutMargins = true
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        ])

        return scrollView
    }

    fileprivate func addMethodsTableView(to superview: UIView) -> UITableView {
        let methodsTableView = List.Table.TableView(frame: CGRect.zero, style: .grouped)
        methodsTableView.separatorStyle = .none
        methodsTableView.backgroundColor = .clear
        methodsTableView.rowHeight = .rowHeight
        methodsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))

        methodsTableView.translatesAutoresizingMaskIntoConstraints = false
        methodsTableView.register(List.Table.SingleLabelCell.self)
        methodsTableView.register(List.Table.DetailedLabelCell.self)
        superview.addSubview(methodsTableView)

        let topPadding: CGFloat = 30

        NSLayoutConstraint.activate([
            methodsTableView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            methodsTableView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            methodsTableView.topAnchor.constraint(equalTo: superview.topAnchor, constant: topPadding)
        ])

        let trailingConstraint = methodsTableView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        trailingConstraint.priority = .defaultHigh
        trailingConstraint.isActive = true

        return methodsTableView
    }
}

// MARK: - PaymentSessionServiceDelegate

extension PaymentListViewController: PaymentSessionServiceDelegate {
    func paymentSessionService(loadingDidCompleteWith result: Load<PaymentSession, ErrorInfo>) {
        self.title = self.sharedTranslationProvider.translation(forKey: "paymentpage.title")

        switch result {
        case .failure(let errorInfo):
            // If it is a communication failure show an alert with a retry option
            if case .COMMUNICATION_FAILURE = Interaction.Reason(rawValue: errorInfo.interaction.reason) {
                var alert = UIAlertController.AlertError(for: errorInfo, translator: sharedTranslationProvider)
                alert.actions = [
                    .init(label: .retry, style: .default) { [loadPaymentSession] _ in
                        loadPaymentSession()
                    },
                    .init(label: .cancel, style: .cancel) { [dismiss] _ in
                        dismiss(.failure(errorInfo))
                    }
                ]
                viewState = .failure(alert)
            // In case of other errors just route the error to a merchant
            } else {
                dismiss(with: .failure(errorInfo))
            }
        case .loading:
            viewState = .loading
        case .success(let session):
            viewState = .success(session)
        }
    }

    func paymentSessionService(shouldSelect network: PaymentNetwork) {
        DispatchQueue.main.async {
            self.show(paymentNetworks: [network], animated: false)
        }
    }
}

// MARK: - ListTableControllerDelegate

extension PaymentListViewController: ListTableControllerDelegate {
    var downloadProvider: DataDownloadProvider { sessionService.downloadProvider }

    func didSelect(paymentNetworks: [PaymentNetwork]) {
        show(paymentNetworks: paymentNetworks, animated: true)
    }

    func didSelect(registeredAccount: RegisteredAccount) {
        show(registeredAccount: registeredAccount, animated: true)
    }
}

// MARK: - NetworkOperationResultHandler

// Received response from InputViewController
extension PaymentListViewController: NetworkOperationResultHandler {
    func paymentController(didReceiveOperationResult result: Result<OperationResult, ErrorInfo>, for network: Input.Network) {
        switch Interaction.Code(rawValue: result.interaction.code) {
        // Display a popup containing the title/text correlating to the INTERACTION_CODE and INTERACTION_REASON (see https://www.optile.io/de/opg#292619) with an OK button. 
        case .TRY_OTHER_ACCOUNT, .TRY_OTHER_NETWORK:
            let errorInfo = ErrorInfo(resultInfo: result.resultInfo, interaction: result.interaction)
            var alertError = UIAlertController.AlertError(for: errorInfo, translator: network.translation)
            alertError.actions = [.init(label: .ok, style: .default) { _ in
                self.loadPaymentSession()
            }]

            viewState = .failure(alertError)
        case .RELOAD:
            // Reload the LIST object and re-render the payment method list accordingly, don't show error alert.
            loadPaymentSession()
        default:
            dismiss(with: result)
        }
    }

    /// Dismiss view controller and send result to a merchant
    private func dismiss(with result: Result<OperationResult, ErrorInfo>) {
        let paymentResult = PaymentResult(operationResult: result)
        delegate?.paymentService(didReceivePaymentResult: paymentResult, viewController: self)
    }
}

extension CGFloat {
    static var rowHeight: CGFloat { return 64 }
}
#endif
